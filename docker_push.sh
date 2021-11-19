#!/bin/bash
./docker_env.sh
docker push ${DOCKER_REPO_NAME}/${IMAGE_NAME}
