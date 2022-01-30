#!/usr/bin/env bash
# TODO: if docker buildx with --push works, then no need to use base image with ARCH in the TAG
# base images  -> sarathy:v0.1.0-amd64 / sarathy:latest-amd64
#              -> sarathy:v0.1.0-arm64 / sarathy:latest-arm64
# child images -> sarathy:v0.1.0-live-amd64 / sarathy:live-amd64
#              -> sarathy:v0.1.0-live-arm64 / sarathy:live-arm64

set -e
DIR=$(dirname $0)
VERSION=v0.1.0

ARCH=${1}
ARCH_SUPPORTED=('amd64' 'arm64') # arch's we have tested for & verified everything
if [[ ! " ${ARCH_SUPPORTED[*]} " =~ " ${1} " ]]; then
    printf "Invalid ARCH value given, supported arch are amd64/arm64\n"
    exit 1
fi

printf "Building for ARCH($ARCH)\n"

IMAGE_REPOSITORY=savyasachi9
BASE_CONTAINER_IMAGE_TAG=${IMAGE_REPOSITORY}/sarathy:${VERSION}-${ARCH}
BASE_CONTAINER_IMAGE_TAG_ALIAS=${IMAGE_REPOSITORY}/sarathy:latest-${ARCH}
BASE_CONTAINER_NAME=sarathy-${VERSION}-${ARCH}

FINAL_CONTAINER_IMAGE_TAG=${IMAGE_REPOSITORY}/sarathy:${VERSION}-live-${ARCH}
FINAL_CONTAINER_IMAGE_TAG_ALIAS=${IMAGE_REPOSITORY}/sarathy:live-${ARCH}
FINAL_CONTAINER_NAME=sarathy-${VERSION}-live-${ARCH}

### 1) build base image for asked arch
docker build --squash -f Dockerfile --platform linux/${ARCH} \
    --build-arg VERSION=${VERSION} \
    -t ${BASE_CONTAINER_IMAGE_TAG} -t ${BASE_CONTAINER_IMAGE_TAG_ALIAS} .

### 2) run base container & install some tools which can't be installed at build time
docker kill ${BASE_CONTAINER_NAME} || true; sleep 6 # stop if already running
#mkdir -p /tmp/.sarathy/dind
docker run --platform linux/${ARCH} \
    -d --rm --privileged -it -h sarathy \
    --name ${BASE_CONTAINER_NAME} \
    ${BASE_CONTAINER_IMAGE_TAG}

printf "\nWaiting a few for base container to be up, expected ARCH(${ARCH})\n"
sleep 12;
docker exec -it --user docker ${BASE_CONTAINER_NAME} arch

# install tools in running container
printf "Installing tools in base container\n"
docker exec -it --user docker ${BASE_CONTAINER_NAME} /scripts/post_build.sh || true
docker exec -it ${BASE_CONTAINER_NAME} rm -rf /scripts || true

### 3) export final container with k8s cluster running with apps deployed
printf "Saving running container as final k8s cluster image\n"
docker commit ${BASE_CONTAINER_NAME} ${FINAL_CONTAINER_IMAGE_TAG}
docker tag ${FINAL_CONTAINER_IMAGE_TAG} ${FINAL_CONTAINER_IMAGE_TAG_ALIAS}

### 4) Run tests on the final container to ensure k8s cluster & related apps got deployed etc
docker kill ${FINAL_CONTAINER_NAME} || true; sleep 6 # stop if already running
printf "Now running the final container\n"
#mkdir -p /tmp/.sarathy/live
docker run --platform linux/${ARCH} \
    -d --rm --privileged -it -h sarathy \
    --name ${FINAL_CONTAINER_NAME} \
    ${FINAL_CONTAINER_IMAGE_TAG}

# TODO: run tests on the final container to make sure that
# - all expected things are there, networking and everything else works etc
docker ps; sleep 45;
docker exec -it --user docker ${FINAL_CONTAINER_NAME} kubectl get pods -A || true

# stop containers gracefully, then force kill just in case still running
docker stop ${BASE_CONTAINER_NAME}
docker stop ${FINAL_CONTAINER_NAME}
docker kill ${BASE_CONTAINER_NAME} ${FINAL_CONTAINER_NAME} || true

# Push images if asked for
if [[ "${2}" == 'push' ]]; then
    printf "\n\n\n=========> Pushing images to docker registry\n"
    docker push ${BASE_CONTAINER_IMAGE_TAG}
    docker push ${BASE_CONTAINER_IMAGE_TAG_ALIAS}

    # TODO: try squashing the final image ??? in Dockerfile have a target whoich inhertits from the final image
    #       then see if we can squash it and save any space
    docker push ${FINAL_CONTAINER_IMAGE_TAG}
    docker push ${FINAL_CONTAINER_IMAGE_TAG_ALIAS}
fi
