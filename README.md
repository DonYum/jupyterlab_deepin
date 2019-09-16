# jupyterlab_quant

构建用于Quant的jupyterlab Docker运行环境。

## 依赖关系

current -> scipy-notebook -> minimal-notebook -> base-notebook

Ref: https://jupyter-docker-stacks.readthedocs.io/en/latest/using/selecting.html

## 使用

```shell
docker build --build-arg NB_USER=renjiangzhe --build-arg NB_UID=`id -u` --build-arg NB_GID=`id -g` --rm -t rjz-jupyter/jupyter-lab .
```

`docker run --rm -p 10000:8888 -e JUPYTER_ENABLE_LAB=yes rjz-jupyter/jupyter-lab`

如果在使用过程中缺少packages，直接安装即可。
