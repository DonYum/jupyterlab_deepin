# Copyright (c) Jupyter Development Team.
# Distributed under the terms of the Modified BSD License.
ARG BASE_CONTAINER=jupyter/scipy-notebook
FROM $BASE_CONTAINER

LABEL maintainer="Jupyter Project <eric_ren@aliyun.com>"

# Install Python 3 packages
RUN conda install pytorch torchvision cpuonly -c pytorch --quiet --yes && \
    conda clean --all -f -y && \
    pip install \
        'plotly-express' \
        'cufflinks' \
        'pyyaml' \
        'arrow' \
        'mongoengine' \
        'seaborn' \
        'tqdm' \
        'chart_studio' \
        'tushare' \
    && \
    # Fix cufflinks version not compatible.
    sed -i 's/import plotly.plotly as py/import chart_studio.plotly as py/g' /opt/conda/lib/python3.7/site-packages/cufflinks/*.py && \
    sed -i 's/from plotly.plotly import plot/from chart_studio.plotly import plot/g' /opt/conda/lib/python3.7/site-packages/cufflinks/*.py && \
    # Install Jupyterlab Extension
    jupyter labextension install @jupyterlab/toc --no-build && \
    jupyter labextension install @jupyterlab/plotly-extension --no-build && \
    jupyter labextension install ipyvolume --no-build && \
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
        # 'fbprophet' \
        # 'pathos' \
    && \
    conda install --quiet --yes \
        'lxml' \
    && \
    conda clean --all -f -y && \
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

RUN mkdir /home/$NB_USER/nb_demo && \
    fix-permissions /home/$NB_USER
COPY nb_demo /home/$NB_USER/nb_demo
RUN fix-permissions /home/$NB_USER

USER $NB_UID