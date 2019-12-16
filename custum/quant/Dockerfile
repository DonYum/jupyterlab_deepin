# Copyright (c) Jupyter Development Team.
# Distributed under the terms of the Modified BSD License.
FROM daocloud.io/eric_ren/quant_jupyter

LABEL maintainer="Jiangzhe Ren<eric_ren@aliyun.com>"
LABEL description="custumed jupyterlab env."

ADD ./ /work_dir
WORKDIR /work_dir

# Install spec packs.
RUN pip install -r ./requirements.txt -i http://mirrors.aliyun.com/pypi/simple --trusted-host mirrors.aliyun.com

CMD ["start-notebook.sh", "--NotebookApp.password='sha1:57b16c557bf1:04515fe200bc0343c27c44be0e716f866f8fcaa9'"]

USER $NB_UID