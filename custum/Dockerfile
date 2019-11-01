# Copyright (c) Jupyter Development Team.
# Distributed under the terms of the Modified BSD License.
FROM daocloud.io/eric_ren/quant_jupyter

MAINTAINER Jiangzhe Ren<eric_ren@aliyun.com>
LABEL description="custumed jupyterlab env."

COPY ./jupyter_notebook_config.py /home/jovyan/.jupyter/jupyter_notebook_config.py
COPY ./jupyter_notebook_config.json /home/jovyan/.jupyter/jupyter_notebook_config.json

ADD ./ /work_dir
WORKDIR /work_dir

# Install spec packs.
# -i http://mirrors.aliyun.com/pypi/simple --trusted-host mirrors.aliyun.com
RUN pip install -r ./requirements.txt

USER $NB_UID