# Copyright (c) Jupyter Development Team.
# Distributed under the terms of the Modified BSD License.
ARG BASE_CONTAINER=jupyter/scipy-notebook
FROM $BASE_CONTAINER

LABEL maintainer="Jupyter Project <eric_ren@aliyun.com>"

# Install Python 3 packages
RUN conda install pytorch torchvision cpuonly -c pytorch --quiet --yes && \
    # conda install --quiet --yes \
    #     'plotly-express' \
    #     'fbprophet' \
    # && \
    conda clean --all -f -y && \
    pip install \
        'plotly-express' \
        'cufflinks' \
        'pyyaml' \
        'arrow' \
        # 'fbprophet' \
        'mongoengine' \
        # 'pathos' \
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

# Install extra Python packages
RUN pip install \
        'tqdm' \
    && \
    # conda install --quiet --yes \
    #     'plotly-express' \
    #     'fbprophet' \
    # && \
    # conda clean --all -f -y && \
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

USER root

# Install TA-Lib which does not have a pip or conda package at the moment
RUN cd /tmp && \
    wget http://prdownloads.sourceforge.net/ta-lib/ta-lib-0.4.0-src.tar.gz && \
    tar -xzf ta-lib-0.4.0-src.tar.gz && \
    cd ta-lib && \
    ./configure --prefix=/usr && make && make install && \
    cd && \
    rm -rf /tmp/ta-lib && \
    fix-permissions $CONDA_DIR && \
    fix-permissions /home/$NB_USER

USER $NB_UID

ENV TA_LIBRARY_PATH /usr/lib
ENV TA_INCLUDE_PATH /usr/include

RUN export TA_LIBRARY_PATH=/usr/lib && \
    export TA_INCLUDE_PATH=/usr/include && \
    pip install 'TA-Lib' && \
    fix-permissions $CONDA_DIR && \
    fix-permissions /home/$NB_USER

USER $NB_UID