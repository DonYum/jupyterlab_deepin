# Copyright (c) Jupyter Development Team.
# Distributed under the terms of the Modified BSD License.

# 使用minimal-notebook替代scipy-notebook
ARG BASE_CONTAINER=jupyter/minimal-notebook
FROM $BASE_CONTAINER

LABEL maintainer="Jiangzhe Ren<eric_ren@aliyun.com>"
LABEL description="jupyterlab env"

# unpin python
USER root
RUN rm -rf $CONDA_DIR/conda-meta/pinned
USER $NB_UID

# Install Python 3 packages
#   手动指定jupyterlab版本
#   -- 使用python3.6： faiss-cpu不支持3.7 --
# RUN conda install --quiet --yes python=3.6 && \
RUN conda install --quiet --yes \
        'jupyterlab=2.1' \
        'ipywidgets' \
        # 'numba' \
        # 'protobuf' \
        'scikit-learn' \
        'scipy' \
        # 'lxml' \
        # 'sqlalchemy' \
        # 'statsmodels' \
        'matplotlib' \
    && \
    # conda install pytorch torchvision cpuonly -c pytorch --quiet --yes && \
    conda clean --all -f -y && \
    pip install \
        'plotly-express' \
        'cufflinks' \
        'pyyaml' \
        # 'seaborn' \
        'tqdm' \
        'chart_studio' \
        'tushare' \
        -i http://mirrors.aliyun.com/pypi/simple --trusted-host mirrors.aliyun.com
    # && \
    # # Fix cufflinks version not compatible.
    # sed -i 's/import plotly.plotly as py/import chart_studio.plotly as py/g' /opt/conda/lib/python3.7/site-packages/cufflinks/*.py && \
    # sed -i 's/from plotly.plotly import plot/from chart_studio.plotly import plot/g' /opt/conda/lib/python3.7/site-packages/cufflinks/*.py

# Install Jupyterlab Extension
    # Activate ipywidgets extension in the environment that runs the notebook server
RUN jupyter nbextension enable --py widgetsnbextension --sys-prefix && \
    # Also activate ipywidgets extension for JupyterLab
    # Check this URL for most recent compatibilities
    # https://github.com/jupyter-widgets/ipywidgets/tree/master/packages/jupyterlab-manager
    jupyter labextension install @jupyter-widgets/jupyterlab-manager --no-build && \
    # jupyter labextension install jupyterlab_bokeh@1.0.0 --no-build && \
    jupyter labextension install @jupyterlab/toc --no-build && \
    jupyter labextension install @jupyterlab/plotly-extension --no-build && \
    # jupyter labextension install ipyvolume --no-build && \
    jupyter labextension install jupyter-threejs --no-build && \
    # Build Jupyterlab Extension
    jupyter lab build --dev-build=False && \
    npm cache clean --force && \
    # Clean cache & fix-permissions
    rm -rf $CONDA_DIR/share/jupyter/lab/staging && \
    rm -rf /home/$NB_USER/.cache/yarn && \
    rm -rf /home/$NB_USER/.node-gyp && \
    fix-permissions $CONDA_DIR && \
    fix-permissions /home/$NB_USER

# # Import matplotlib the first time to build the font cache.
# ENV XDG_CACHE_HOME /home/$NB_USER/.cache/
# RUN MPLBACKEND=Agg python -c "import matplotlib.pyplot" && \
#     fix-permissions /home/$NB_USER

# Install TA-Lib which does not have a pip or conda package at the moment
USER root
RUN cd /tmp && \
    wget http://prdownloads.sourceforge.net/ta-lib/ta-lib-0.4.0-src.tar.gz && \
    tar -xzf ta-lib-0.4.0-src.tar.gz && \
    cd ta-lib && \
    ./configure --prefix=/usr && make && make install && \
    cd && \
    rm -rf /tmp/ta-lib && \
    # # install zh fonts
    # cd /tmp && \
    # git clone https://github.com/neroxps/Docker-Only-Office-Chinese-font.git && \
    # cd Docker-Only-Office-Chinese-font/ && \
    # cp -a winfont /usr/share/fonts/ && \
    # fc-cache -f -v && \
    # cd && \
    # rm -rf Docker-Only-Office-Chinese-font/ && \
    fix-permissions $CONDA_DIR && \
    fix-permissions /home/$NB_USER

USER $NB_UID

ENV TA_LIBRARY_PATH=/usr/lib \
    TA_INCLUDE_PATH=/usr/include

# Install extra Python packages
RUN pip install \
        'TA-Lib' \
        -i http://mirrors.aliyun.com/pypi/simple --trusted-host mirrors.aliyun.com \
    && \
    # # Install Jupyterlab Extension
    # jupyter labextension install jupyter-threejs --no-build && \
    # # Build Jupyterlab Extension
    # jupyter lab build --dev-build=False && \
    # npm cache clean --force && \
    # # Clean cache & fix-permissions
    # rm -rf $CONDA_DIR/share/jupyter/lab/staging && \
    # rm -rf /home/$NB_USER/.cache/yarn && \
    # rm -rf /home/$NB_USER/.node-gyp && \
    fix-permissions $CONDA_DIR && \
    fix-permissions /home/$NB_USER

ADD ./requirements.txt /

# build a basic http/Async services env.
RUN pip install -r /requirements.txt -i http://mirrors.aliyun.com/pypi/simple --trusted-host mirrors.aliyun.com

# RUN mkdir /home/$NB_USER/nb_demo && \
#     fix-permissions /home/$NB_USER
# COPY nb_demo /home/$NB_USER/nb_demo
# RUN fix-permissions /home/$NB_USER

USER $NB_UID
