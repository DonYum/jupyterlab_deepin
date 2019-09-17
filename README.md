# jupyterlab_quant

构建用于Quant的jupyterlab Docker运行环境。

## 依赖关系

current -> scipy-notebook -> minimal-notebook -> base-notebook

Ref: https://jupyter-docker-stacks.readthedocs.io/en/latest/using/selecting.html

## 使用

### 环境配置

- 配置daocloud源

    `curl -sSL https://get.daocloud.io/daotools/set_mirror.sh | sh -s http://f1361db2.m.daocloud.io`

    Ref: https://www.daocloud.io/mirror

- docker-compose安装

    Ref: https://docs.docker.com/compose/install/

### quick start

```sh
git clone https://github.com/DonYum/jupyterlab_quant.git
cd jupyterlab_quant
WORK_DIR=~/jupyter PORT=20001  UID=${UID} GID=${GID} docker-compose up
```

其中：

- WORK_DIR: 工作目录
- PORT: 暴露的端口

### Run by specified cmd (img from daocloud)

```sh
docker run --rm -p 20001:8888 --user root -v "$PWD":/home/jovyan/work -e JUPYTER_ENABLE_LAB=yes -e NB_UID=`id -u` -e NB_GID=`id -g` -v /etc/localtime:/etc/localtime daocloud.io/eric_ren/quant_jupyter
```

Ref: https://hub.daocloud.io/repos/844278c8-9f16-4aa8-84e3-89fc80e7c3cf

### Build img by yourself

```sh
# docker build --build-arg NB_USER=renjiangzhe --build-arg NB_UID=`id -u` --build-arg NB_GID=`id -g` --rm -t quant/jupyter-lab .
docker build --rm -t quant/jupyter-lab .
```

如果在使用过程中缺少packages，直接安装即可。

## TODO

- TA-Lib
