# Deepin Jupyterlab

构建开箱即用的jupyterlab Docker运行环境。

## quick start

### 配置daocloud源

    `curl -sSL https://get.daocloud.io/daotools/set_mirror.sh | sh -s http://f1361db2.m.daocloud.io`

    Ref: https://www.daocloud.io/mirror

### docker-compose安装

    Ref: https://docs.docker.com/compose/install/

### 启动

```sh
docker pull daocloud.io/eric_ren/quant_jupyter
git clone https://github.com/DonYum/jupyterlab_deepin.git
cd jupyterlab_deepin/custom/simple
WORK_DIR=~/jupyter PORT=20001 NAME=code_test UID=${UID} GID=${GID} docker-compose up
```

其中：

- WORK_DIR: 工作目录
- PORT: 暴露的端口

默认密码：`11112222`

## 配置

### 安装特定包

- jupyter里面直接安装或启动terminal安装；
- 启动后exec进去安装；
- 修改`requirement.txt`文件后重新启动。

### 挂载指定目录

在`docker-compose.yaml`里的`volumes`参数后面添加即可。

### 定制密码

事先生成一个密码hash：

```python
from notebook.auth import passwd; passwd()
```

然后修改Dockerfile文件的CMD位置，然后docker-compose启动即可。

### 修改jupyter配置

不建议直接修改`jupyter_notebook_config.py`文件，可以在Dockerfile文件的CMD后面加参数。

*密码可以由参数方式启动：https://jupyter-docker-stacks.readthedocs.io/en/latest/using/common.html#notebook-options*

## 其他

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

## 依赖关系

current -> scipy-notebook -> minimal-notebook -> base-notebook

Ref: https://jupyter-docker-stacks.readthedocs.io/en/latest/using/selecting.html

## TODO

- 目前还不支持faiss-cpu，原因是python3.7不支持。解决方法：1. 用data_pf docker做基板（意味着data_pf和其他场景的jupyter要隔离开了，而且要解决权限问题）；2. unpin python，install python3.6（不可行）；
- matplotlib中文字体；
