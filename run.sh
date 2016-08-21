#!/bin/bash -e

# An example script to run Postfix in production. It uses data volumes under the $DATA_ROOT directory.
# By default /srv.

NAME='jenkins'
DATA_ROOT='/opt/docker-containers'
JENKINS_DATA="${DATA_ROOT}/${NAME}"

HOST_NAME=jenkins
NETWORK_NAME=dev_nw
AGENT_PORT=50000
WEB_PORT=8060

mkdir -p "$JENKINS_DATA"

docker stop "${NAME}" 2>/dev/null && sleep 1
docker rm "${NAME}" 2>/dev/null && sleep 1
docker run --detach=true --name "${NAME}" --hostname "${HOST_NAME}" \
    --volume "${JENKINS_DATA}:/var/jenkins_home" \
    --network=${NETWORK_NAME} \
    -p $WEB_PORT:8080 \
    -p $AGENT_PORT:50000 \
    redwyvern/jenkins
