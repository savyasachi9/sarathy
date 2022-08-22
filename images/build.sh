#!/usr/bin/env bash
# TODO: if docker buildx with --push works, then no need to use base image with ARCH in the TAG
# base images        -> sarathy:base-ARCH-VERSION / sarathy:base-amd64-v0.1.0 | sarathy:base-arm64-v0.1.0
#                    -> sarathy:base-ARCH / sarathy:base-amd64 | sarathy:base-arm64
#
# child images
#                    -> sarathy:latest-ARCH-VERSION / sarathy:latest-amd64-v0.1.0 | sarathy:latest-arm64-v0.1.0
#                    -> sarathy:latest-ARCH  / sarathy:latest-amd64 | sarathy:latest-arm64
#
# live k8s images    -> sarathy:K8S_CLUSTER-K8S_VERSION-ARCH-VERSION / sarathy:minikube-amd64-v0.1.0 | sarathy:minikube-arm64-v0.1.0
# mkube/k3s, redis   -> sarathy:K8S_CLUSTER-K8S_VERSION-ARCH         / sarathy:minikube-amd64 | sarathy:minikube-amd64
# mysql, PLT etc

# sarathy-base-amd64 -> sarathy:latest-amd64 -> sarathy:minikube-amd64 | sarathy:k3s-amd64
#
# usage: (amd64/arm64 for ARG $1)
# ./images/build.sh amd64
# ./images/build.sh amd64 skip-live
# ./images/build.sh amd64 push
# ./images/build.sh amd64 just-push
# K8S_CLUSTER=minikube ./images/build.sh amd64
# K8S_CLUSTER=k3s ./images/build.sh amd64
# BUILD_BASE=no BUILD_LATEST=no ./images/build.sh amd64
set -e
DIR=$(dirname $0)
VERSION=v0.2.0
# TODO: err / EXIT if not run from sarathy root

ARCH=$1 #$(arch)
ARCH_ALIAS=${ARCH}
if [[ $ARCH == 'x86_64' ]]; then ARCH='amd64'; fi
if [[ $ARCH == 'amd64' ]]; then ARCH_ALIAS='x86_64'; fi

BUILD_PLT=${BUILD_PLT:-'no'}
BUILD_BASE=${BUILD_BASE:-'yes'}
BUILD_LATEST=${BUILD_LATEST:-'yes'}
BUILD_LIVE=${BUILD_LIVE:-'yes'}

PUSH_IMAGES='no'
JUST_PUSH_IMAGES='no'
if  [[ $2 == 'push' ]]; then PUSH_IMAGES='yes'; fi
if  [[ $2 == 'just-push' ]]; then JUST_PUSH_IMAGES='yes'; fi

# arch's & k8s clusters we support, have tested for & verified everything with
ARCH_SUPPORTED=('amd64' 'arm64')
K8S_CLUSTERS_SUPPORTED=('minikube' 'k3s') # minikube, k3s, kind, k0s, microk8s
if [[ ! " ${ARCH_SUPPORTED[*]} " =~ " ${ARCH} " ]]; then
    printf "Invalid ARCH(${ARCH}) value given, supported arch are:\n${ARCH_SUPPORTED[*]}\n"
    exit 1
fi

K8S_CLUSTER=${K8S_CLUSTER:-'minikube'} # default is minikube
K8S_VERSION=${K8S_VERSION:-'v1.23.9'}  # default is v1.23.9 which still supports docker as the shim
K8S_VERSION_TAG=''
#if [[ $K8S_VERSION != '' ]]; then K8S_VERSION_TAG="-k8s${K8S_VERSION}"; fi

if [[ ! " ${K8S_CLUSTERS_SUPPORTED[*]} " =~ " ${K8S_CLUSTER} " ]]; then
    printf "Invalid K8S_CLUSTER value given, supported k8s clusters are:\n${K8S_CLUSTERS_SUPPORTED[*]}\n"
    exit 1
fi

IMAGE_REPOSITORY=savyasachi9
LANGTOOLS_CONTAINER_IMAGE_TAG=${IMAGE_REPOSITORY}/langtools:${ARCH}-${VERSION}
LANGTOOLS_CONTAINER_IMAGE_TAG_ALIAS=${IMAGE_REPOSITORY}/langtools:${ARCH}
LANGTOOLS_CONTAINER_NAME=sarathy-lang-tools-${ARCH}

BASE_CONTAINER_IMAGE_TAG=${IMAGE_REPOSITORY}/sarathy:base-${ARCH}-${VERSION}
BASE_CONTAINER_IMAGE_TAG_ALIAS=${IMAGE_REPOSITORY}/sarathy:base-${ARCH}
BASE_CONTAINER_NAME=sarathy-base-${ARCH}

LATEST_CONTAINER_IMAGE_TAG=${IMAGE_REPOSITORY}/sarathy:latest-${ARCH}-${VERSION}
LATEST_CONTAINER_IMAGE_TAG_ALIAS=${IMAGE_REPOSITORY}/sarathy:latest-${ARCH}
LATEST_CONTAINER_NAME=sarathy-latest-${ARCH}

FINAL_CONTAINER_IMAGE_TAG=${IMAGE_REPOSITORY}/sarathy:${K8S_CLUSTER}${K8S_VERSION_TAG}-${ARCH}-${VERSION}
FINAL_CONTAINER_IMAGE_TAG_ALIAS=${IMAGE_REPOSITORY}/sarathy:${K8S_CLUSTER}${K8S_VERSION_TAG}-${ARCH}
FINAL_CONTAINER_NAME=sarathy-${K8S_CLUSTER}-${ARCH}

push_images(){
  printf "\n\n\n=========> Pushing base images to docker registry\n"
  docker push ${BASE_CONTAINER_IMAGE_TAG}
  docker push ${BASE_CONTAINER_IMAGE_TAG_ALIAS}

  # NOTE: latest image with PLT is based off of minikube image
  # TODO: switch to k3s if it's any better on resource consumption than minikube
  if [[ $K8S_CLUSTER == 'minikube' ]]; then
    printf "\n\n\n=========> Pushing latest images to docker registry\n"
    docker push ${LATEST_CONTAINER_IMAGE_TAG}
    docker push ${LATEST_CONTAINER_IMAGE_TAG_ALIAS}
  fi

  printf "\n\n\n=========> Pushing final images to docker registry\n"
  docker push ${FINAL_CONTAINER_IMAGE_TAG}
  docker push ${FINAL_CONTAINER_IMAGE_TAG_ALIAS}
}

# Skip building & just push images from last build, need to ensure manually that they exist before pushing
if [[ $JUST_PUSH_IMAGES == 'yes' ]]; then
  push_images
  exit 0
fi

printf "Building for ARCH($ARCH) & K8S_CLUSTER($K8S_CLUSTER) K8S_VERSION($K8S_VERSION)\n"
# IMP: if below are empty then c/cpp debugger & default vscode settings won't work
# TODO: move these as part of examples default settings & copy from there
mkdir -p ${DIR}/vscode/extensions-${ARCH} ${DIR}/vscode/.vscode

### -1) build PLT (prog lang tools)
### TODO: build this using buildx for multi arch such that we don't need todo langtools-arch image tags
if [[ $BUILD_PLT == 'yes' ]]; then
  printf "Building PLT\n"

  docker build --squash -f images/Dockerfile.langtools --platform linux/${ARCH} \
      --build-arg VERSION=${VERSION} --build-arg ARCH=${ARCH} --build-arg ARCH_ALIAS=${ARCH_ALIAS} \
      -t ${LANGTOOLS_CONTAINER_IMAGE_TAG} -t ${LANGTOOLS_CONTAINER_IMAGE_TAG_ALIAS} .

  printf "Pushing PLT ...\n"
  docker push ${LANGTOOLS_CONTAINER_IMAGE_TAG}
  docker push ${LANGTOOLS_CONTAINER_IMAGE_TAG_ALIAS}
fi

### 0) build base image for asked arch
if [[ $BUILD_BASE == 'yes' ]]; then
  docker build --squash -f ${DIR}/Dockerfile --platform linux/${ARCH} --target sarathy-base \
      --build-arg VERSION=${VERSION} --build-arg ARCH=${ARCH} --build-arg ARCH_ALIAS=${ARCH_ALIAS} \
      --build-arg K8S_CLUSTER=${K8S_CLUSTER} \
      -t ${BASE_CONTAINER_IMAGE_TAG} -t ${BASE_CONTAINER_IMAGE_TAG_ALIAS} .
fi

### 1) build latest image for asked arch
if [[ $BUILD_LATEST == 'yes' ]]; then
  docker build --squash -f ${DIR}/Dockerfile --platform linux/${ARCH} --target sarathy-latest \
      --build-arg VERSION=${VERSION} --build-arg ARCH=${ARCH} --build-arg ARCH_ALIAS=${ARCH_ALIAS} \
      --build-arg K8S_CLUSTER=${K8S_CLUSTER} \
      -t ${LATEST_CONTAINER_IMAGE_TAG} -t ${LATEST_CONTAINER_IMAGE_TAG_ALIAS} .
fi

if [[ $BUILD_LIVE == 'no' ]]; then
    printf "Just building base + latest images & skipping building live\n"; exit 0;
fi

### 2) run latest container & install some tools which can't be installed at build time
# k3s specific : --tmpfs /run --tmpfs /var/run
docker kill ${LATEST_CONTAINER_NAME} || true; sleep 6 # stop if already running
docker run --platform linux/${ARCH} \
    -d --rm --privileged -it -h sarathy \
    --name ${LATEST_CONTAINER_NAME} \
    ${LATEST_CONTAINER_IMAGE_TAG}

printf "\nWaiting a few for latest container to be up, expected ARCH(${ARCH})\n"
sleep 12;
docker exec -it --user docker ${LATEST_CONTAINER_NAME} arch

# install plt service (NOTE: this'll add like 2G+ to the image size)
# TODO: increase start timeout for plt systemd service such that we don't have to docker pull the image here
docker exec -it --user docker ${LATEST_CONTAINER_NAME} /bin/bash -c "docker pull ${LANGTOOLS_CONTAINER_IMAGE_TAG_ALIAS}" || true
docker exec -it --user docker ${LATEST_CONTAINER_NAME} /bin/bash -c "sudo systemctl enable plt && sudo systemctl start plt" || true

# install tools in running container
printf "Installing k8s cluster (${K8S_CLUSTER}) with tools & default apps in latest container\n"
docker exec -it --user docker ${LATEST_CONTAINER_NAME} \
    /bin/bash -c "source /scripts/install.sh && install_k8s_cluster ${K8S_CLUSTER} '${K8S_VERSION}' yes" || true

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
# TODO: these tests fail for k3s, add SLEEP ?
docker ps; sleep 45;
docker exec -it --user docker ${FINAL_CONTAINER_NAME} \
  /bin/bash -c "kubectl get pods -A; docker ps; docker images;" || true

# stop containers gracefully, then force kill just in case still running
docker stop ${LATEST_CONTAINER_NAME}
docker stop ${FINAL_CONTAINER_NAME}
docker kill ${LATEST_CONTAINER_NAME} ${FINAL_CONTAINER_NAME} || true

# Push images if asked for
if [[ $PUSH_IMAGES == 'yes' ]]; then
  push_images
fi