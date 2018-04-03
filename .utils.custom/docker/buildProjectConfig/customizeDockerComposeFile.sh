#!/usr/bin/env bash

# example

## workspace WORKSPACE_SSH_PORT removal
#sed -i ':a;N;$!ba;s/      extra_hosts:\n\        - "dockerhost:${DOCKER_HOST_IP}"\n\      ports:\n\        - "${WORKSPACE_SSH_PORT}:22"/      extra_hosts:\n\        - "dockerhost:${DOCKER_HOST_IP}"/' ${LARADOCK_DIRECTORY_PATH}docker-compose.yml