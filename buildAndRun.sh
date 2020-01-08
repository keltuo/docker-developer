#!/bin/bash

if [ -z "$1" ]; then echo "Specify apache port"; exit; fi
if [ -z "$2" ]; then echo "Specify container name"; exit; fi
if [ -z "$3" ]; then echo "Specify path for application"; exit; fi
if [ -z "$4" ]; then
    DOCKER_ENGINE="docker"
else
    if [[ "$4" == "docker" ]] || [[ "$4" == "docker-compose" ]]; then
        DOCKER_ENGINE=$4
    else
        echo "Specify docker engine \"docker\" or \"docker-compose\""; exit;
    fi
fi
## configurations
APACHE_PORT=$1
DEVELOPER=$2
APPLICATION_PATH=$3
SERVICE="${DEVELOPER}"
DOCKERFILE_PATH="${APPLICATION_PATH}/build/docker/developer/Dockerfile"
DOCKER_COMPOSE_FILE_PATH="${APPLICATION_PATH}/build/docker/developer/docker-compose.yml"

eval "echo \"$(cat build/docker/developer/env.tpl)\"" > build/docker/developer/env
echo "$(cat build/docker/developer/env; cat build/docker/developer/dcp.tpl)" > build/docker/developer/dcp
chmod +x build/docker/developer/dcp
rm -rf build/docker/developer/env


# build container
echo "BUILDING DOCKER"
if [ "$4" == "docker" ]; then
    docker build -t ${SERVICE} -f ${DOCKERFILE_PATH} .

    # run container
    echo "STOPPING PREVIOUS VERSION"
    docker rm -f ${SERVICE}

    echo "RUNNING DOCKER"
    docker run --name=${SERVICE} --restart=unless-stopped -p ${APACHE_PORT}:80 \
     -v ${APPLICATION_PATH}:/var/www/html \
     -v $(dirname $SSH_AUTH_SOCK):$(dirname $SSH_AUTH_SOCK) \
     -e SSH_AUTH_SOCK=$SSH_AUTH_SOCK \
     -d ${SERVICE}
else
    build/docker/developer/dcp upfile ${DOCKER_COMPOSE_FILE_PATH}
fi