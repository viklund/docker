#!/usr/bin/env bash

DIR_PATH="$( cd "$( echo "${0%/*}" )"; pwd )"
if [[ $DIR_PATH == */* ]]; then
	cd $DIR_PATH
fi

DOCKER_NAME=$1

if [ "x$DOCKER_NAME" == "x" ]; then
    echo "Usage: $0 <name>"
    exit;
fi

source run.conf

have_docker_container_name ()
{
	NAME=$1

	if [[ -n $(docker ps -a | grep -v -e "${NAME}/.*,.*" | grep -o ${NAME}) ]]; then
		return 0
	else
		return 1
	fi
}

is_docker_container_name_running ()
{
	NAME=$1

	if [[ -n $(docker ps | grep -v -e "${NAME}/.*,.*" | grep -o ${NAME}) ]]; then
		return 0
	else
		return 1
	fi
}

if is_docker_container_name_running ${DOCKER_NAME} ; then
    echo "The ${DOCKER_NAME} is already running"
    exit
elif have_docker_container_name ${DOCKER_NAME} ; then
    echo "The ${DOCKER_NAME} already exists, starting..."
    (
    set -x
    docker start ${DOCKER_NAME}
    )
else
    # In a sub-shell set xtrace - prints the docker command to screen for reference
    (
    set -x
    docker run \
        -d \
        --name ${DOCKER_NAME} \
        -P \
        ${DOCKER_IMAGE_REPOSITORY_NAME}
    )
fi

if is_docker_container_name_running ${DOCKER_NAME} ; then
	docker ps | grep -v -e "${DOCKER_NAME}/.*,.*" | grep ${DOCKER_NAME}
	echo " ---> Docker container running."
fi
