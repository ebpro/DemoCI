#!/bin/bash
source ./docker_env.sh
docker run --rm -it ${DOCKER_REPO_NAME}/${IMAGE_NAME}
