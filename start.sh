# Can not work: why UID & GID can not pass to docker-compose script?

# Pls specify WORK_DIR:
export WORK_DIR=${PWD}

# export UID=${UID}
# export GID=${GID}
UID=${UID} GID=${GID} docker-compose up