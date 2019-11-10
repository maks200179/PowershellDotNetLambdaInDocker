#!/bin/bash
set -x


DIR=$(dirname "$(readlink -f "$0")")






	
git_dir="/puppet_data/.git"
if [[ -d ${git_dir} ]]; then 
    rm -fr "${git_dir}"
    echo "git dir removed"
fi	
	
	
if [[ ! $(docker ps -a | grep 'powershell') ]] ; then
    docker-compose  -f "${DIR}"/docker_env/docker-compose.yml up -d --build powershell
fi
