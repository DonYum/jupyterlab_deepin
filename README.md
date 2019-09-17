# jupyterlab_quant

构建用于Quant的jupyterlab Docker运行环境。

## 依赖关系

current -> scipy-notebook -> minimal-notebook -> base-notebook

Ref: https://jupyter-docker-stacks.readthedocs.io/en/latest/using/selecting.html

## 使用

### pull from daocloud

```sh
docker run --rm -p 20001:8888 --user root -v "$PWD":/home/jovyan/work -e JUPYTER_ENABLE_LAB=yes -e NB_UID=`id -u` -e NB_GID=`id -g` -v /etc/localtime:/etc/localtime daocloud.io/eric_ren/quant_jupyter
```

Ref: https://dashboard.daocloud.io/build-flows/4eaf3d3a-ea20-4a8c-be49-7f4d91d6cf2a

### build by yourself

```sh
# docker build --build-arg NB_USER=renjiangzhe --build-arg NB_UID=`id -u` --build-arg NB_GID=`id -g` --rm -t quant/jupyter-lab .
docker build --rm -t quant/jupyter-lab .
```

`docker run --rm -p 10000:8888 -e JUPYTER_ENABLE_LAB=yes quant/jupyter-lab`

如果在使用过程中缺少packages，直接安装即可。

## TODO

- TA-Lib
