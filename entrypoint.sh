#!/bin/bash

DOKKU_SERVER_HOST=$1
DOKKU_SERVER_USERNAME=$2
DOKKU_SERVER_KEY=$3
DOKKU_APP_NAME=$4
GITHUB_DOCKER_IMAGE_REPOSITORY=$5
GITHUB_TOKEN=$6

# ssh resolution
mkdir -p ~/.ssh
eval `ssh-agent -s`
ssh-add - <<< "${DOKKU_SERVER_KEY}"
ssh-keyscan $DOKKU_SERVER_HOST >> ~/.ssh/known_hosts

# local vars
github_repo="https://docker.pkg.github.com/"
tagname="${GITHUB_REF##*/}"
username="${GITHUB_ACTOR}"
image_repo="docker.pkg.github.com/${GITHUB_DOCKER_IMAGE_REPOSITORY}:${tagname}"

# commands
login="docker login ${github_repo} -u ${username} --password ${GITHUB_TOKEN}"
pull="docker pull ${image_repo}"
tag="docker tag ${image_repo} dokku/${DOKKU_APP_NAME}:${tagname}"
deploy="dokku tags:deploy ${DOKKU_APP_NAME} ${tagname}"

exec_command="ssh -o UserKnownHostsFile=/dev/null -o StrictHostKeyChecking=no ${DOKKU_SERVER_USERNAME}@${DOKKU_SERVER_HOST}"

# execution
eval "$exec_command \"$login\""
eval "$exec_command \"$pull\""
eval "$exec_command \"$tag\""
eval "$exec_command \"$deploy\""
