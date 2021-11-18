source ./docker_env.sh
DOCKER_BUILDKIT=1 docker build -t ${DOCKER_REPO_NAME}/${IMAGE_NAME} .
