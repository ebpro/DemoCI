DOCKER_REPO_NAME=brunoe
IMAGE_NAME=`echo ${PWD##*/}| tr '[:upper:]' '[:lower:]'`
IMAGE_TAG=`git rev-parse --abbrev-ref HEAD`
