#!/bin/bash
set -x


DIR=$(dirname "$(readlink -f "$0")")

	
if [[ ! $(docker ps -a | grep 'powershell') ]] ; then
    docker-compose  -f "${DIR}"/docker_env/docker-compose.yml up -d --build powershell
fi
