#!/usr/bin/env bash
# TODO: if docker buildx with --push works, then no need to use base image with ARCH in the TAG
# base images        -> sarathy:base-ARCH-VERSION / sarathy:base-amd64-v0.1.0 | sarathy:base-arm64-v0.1.0
#                    -> sarathy:base-ARCH / sarathy:base-amd64 | sarathy:base-arm64
#
# child images
# latest with PLT    -> sarathy:latest-ARCH-VERSION / sarathy:latest-amd64-v0.1.0 | sarathy:latest-arm64-v0.1.0
# prog lang tools    -> sarathy:latest-ARCH  / sarathy:latest-amd64 | sarathy:latest-arm64
#
# live k8s images    -> sarathy:K8S_CLUSTER-K8S_VERSION-ARCH-VERSION / sarathy:minikube-amd64-v0.1.0 | sarathy:minikube-arm64-v0.1.0
#                    -> sarathy:K8S_CLUSTER-K8S_VERSION-ARCH         / sarathy:minikube-amd64 | sarathy:minikube-amd64
#
# sarathy-base-amd64 -> sarathy:latest-amd64 -> sarathy:minikube-amd64 | sarathy:k3s-amd64
#
# usage:
# ./build.sh skip-live
# ./build.sh push
# K8S_VERSION=v1.23.3 K8S_CLUSTER=minikube ./build.sh
set -e
DIR=$(dirname $0)
VERSION=v0.1.0

ARCH=$(arch)
ARCH_ALIAS=${ARCH}
if [[ $ARCH == 'x86_64' ]]; then ARCH='amd64'; fi
if [[ $ARCH == 'amd64' ]]; then ARCH_ALIAS='x86_64'; fi

# arch's & k8s clusters we support, have tested for & verified everything with
ARCH_SUPPORTED=('amd64' 'arm64')
K8S_CLUSTERS_SUPPORTED=('minikube')
if [[ ! " ${ARCH_SUPPORTED[*]} " =~ " ${ARCH} " ]]; then
    printf "Invalid ARCH(${ARCH}) value given, supported arch are:\n${ARCH_SUPPORTED[*]}\n"
    exit 1
fi

K8S_CLUSTER=${K8S_CLUSTER:-'minikube'} # default is minikube
K8S_VERSION=${K8S_VERSION:-''}         # default is latest
K8S_VERSION_TAG=''
if [[ $K8S_VERSION != '' ]]; then K8S_VERSION_TAG="-k8s${K8S_VERSION}"; fi

if [[ ! " ${K8S_CLUSTERS_SUPPORTED[*]} " =~ " ${K8S_CLUSTER} " ]]; then
    printf "Invalid K8S_CLUSTER value given, supported k8s clusters are:\n${K8S_CLUSTERS_SUPPORTED[*]}\n"
    exit 1
fi

IMAGE_REPOSITORY=savyasachi9

BASE_CONTAINER_IMAGE_TAG=${IMAGE_REPOSITORY}/sarathy:base-${ARCH}-${VERSION}
BASE_CONTAINER_IMAGE_TAG_ALIAS=${IMAGE_REPOSITORY}/sarathy:base-${ARCH}
BASE_CONTAINER_NAME=sarathy-base-${ARCH}

LATEST_CONTAINER_IMAGE_TAG=${IMAGE_REPOSITORY}/sarathy:latest-${ARCH}-${VERSION}
LATEST_CONTAINER_IMAGE_TAG_ALIAS=${IMAGE_REPOSITORY}/sarathy:latest-${ARCH}
LATEST_CONTAINER_NAME=sarathy-latest-${ARCH}

FINAL_CONTAINER_IMAGE_TAG=${IMAGE_REPOSITORY}/sarathy:${K8S_CLUSTER}${K8S_VERSION_TAG}-${ARCH}-${VERSION}
FINAL_CONTAINER_IMAGE_TAG_ALIAS=${IMAGE_REPOSITORY}/sarathy:${K8S_CLUSTER}${K8S_VERSION_TAG}-${ARCH}
FINAL_CONTAINER_NAME=sarathy-${K8S_CLUSTER}-${ARCH}

printf "Building for ARCH($ARCH) & K8S_CLUSTER($K8S_CLUSTER) K8S_VERSION($K8S_VERSION)\n"

### 0) build base image for asked arch
docker build --squash -f Dockerfile --platform linux/${ARCH} --target sarathy-base \
    --build-arg VERSION=${VERSION} --build-arg ARCH=${ARCH} --build-arg ARCH_ALIAS=${ARCH_ALIAS} \
    -t ${BASE_CONTAINER_IMAGE_TAG} -t ${BASE_CONTAINER_IMAGE_TAG_ALIAS} .

### 1) build latest image for asked arch
docker build --squash -f Dockerfile --platform linux/${ARCH} --target sarathy-latest \
    --build-arg VERSION=${VERSION} --build-arg ARCH=${ARCH} --build-arg ARCH_ALIAS=${ARCH_ALIAS} \
    -t ${LATEST_CONTAINER_IMAGE_TAG} -t ${LATEST_CONTAINER_IMAGE_TAG_ALIAS} .

if [[ $1 == 'skip-live' ]]; then
    printf "Just building base + latest images & skipping runnig post build scripts\n"; exit 0;
fi

### 2) run latest container & install some tools which can't be installed at build time
docker kill ${LATEST_CONTAINER_NAME} || true; sleep 6 # stop if already running
docker run --platform linux/${ARCH} \
    -d --rm --privileged -it -h sarathy \
    --name ${LATEST_CONTAINER_NAME} \
    ${LATEST_CONTAINER_IMAGE_TAG}

printf "\nWaiting a few for latest container to be up, expected ARCH(${ARCH})\n"
sleep 12;
docker exec -it --user docker ${LATEST_CONTAINER_NAME} arch

# install tools in running container
printf "Installing k8s cluster (${K8S_CLUSTER}) with tools & default apps in latest container\n"
docker exec -it --user docker ${LATEST_CONTAINER_NAME} /bin/bash -c "source /scripts/install.sh && install_k8s_cluster minikube '${K8S_CLUSTER_VERSION}' yes" || true

### 3) export final container with k8s cluster running with apps deployed
printf "Saving running container as final k8s cluster image\n"
docker commit ${LATEST_CONTAINER_NAME} ${FINAL_CONTAINER_IMAGE_TAG}
docker tag ${FINAL_CONTAINER_IMAGE_TAG} ${FINAL_CONTAINER_IMAGE_TAG_ALIAS}

### 4) Run tests on the final container to ensure k8s cluster & related apps got deployed etc
docker kill ${FINAL_CONTAINER_NAME} || true; sleep 6 # stop if already running
printf "Now running the final container\n"
docker run --platform linux/${ARCH} \
    -d --rm --privileged -it -h sarathy \
    --name ${FINAL_CONTAINER_NAME} \
    ${FINAL_CONTAINER_IMAGE_TAG}

# TODO: run tests on the final container to make sure that
# - all expected things are there, networking and everything else works etc
docker ps; sleep 45;
docker exec -it --user docker ${FINAL_CONTAINER_NAME} kubectl get pods -A || true

# stop containers gracefully, then force kill just in case still running
docker stop ${LATEST_CONTAINER_NAME}
docker stop ${FINAL_CONTAINER_NAME}
docker kill ${LATEST_CONTAINER_NAME} ${FINAL_CONTAINER_NAME} || true

# Push images if asked for
if [[ $1 == 'push' ]]; then
    printf "\n\n\n=========> Pushing images to docker registry\n"
    docker push ${BASE_CONTAINER_IMAGE_TAG}
    docker push ${BASE_CONTAINER_IMAGE_TAG_ALIAS}

    docker push ${LATEST_CONTAINER_IMAGE_TAG}
    docker push ${LATEST_CONTAINER_IMAGE_TAG_ALIAS}

    docker push ${FINAL_CONTAINER_IMAGE_TAG}
    docker push ${FINAL_CONTAINER_IMAGE_TAG_ALIAS}
fi