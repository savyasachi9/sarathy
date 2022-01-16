#!/usr/bin/env bash
set -e
DIR=$(dirname $0)
VERSION=v0.1.0

### 0) build binaries container image
docker build --squash -f ${DIR}/Dockerfile.binaries -t savyasachi9/binaries:${VERSION} -t savyasachi9/binaries:latest .

### 1) build cluster container image (TODO: build for multi arch using dockerx)
docker build --squash -f ${DIR}/Dockerfile --build-arg VERSION=${VERSION} -t savyasachi9/sarathy:${VERSION} -t savyasachi9/sarathy:latest .

### 2) run base container & install some tools which can't be installed at build time
docker kill sarathy-${VERSION} || true
mkdir -p /tmp/.sarathy/dind
docker run --rm -d \
    --mount type=bind,source=/tmp/.sarathy/dind,target=/var/lib/docker \
    --privileged -it -h minikube --name sarathy-${VERSION} \
    savyasachi9/sarathy:${VERSION}

printf "Sleeping for sometime for container to be up\n"
sleep 9 && docker ps

# install tools in running container
printf "Installing tools in base container\n"
docker exec -it --user docker sarathy-${VERSION} /scripts/post_build.sh

### 3) export final container with k8s cluster running with apps deployed
docker commit sarathy-${VERSION} savyasachi9/sarathy:${VERSION}-minikube
docker tag savyasachi9/sarathy:${VERSION}-minikube savyasachi9/sarathy:minikube

# stop base container gracefully
docker exec -it --user docker sarathy-${VERSION} sudo shutdown now
docker images | grep savyasachi9 | grep ${VERSION} && docker ps

printf "Now running the final container\n"
docker kill sarathy-${VERSION}-minikube || true
mkdir -p /tmp/.sarathy/minikube
docker run -d --rm \
    --mount type=bind,source=/tmp/.sarathy/minikube,target=/var/lib/docker \
    --privileged -it -h minikube --name sarathy-${VERSION}-minikube \
    savyasachi9/sarathy:${VERSION}-minikube

# TODO: run tests on the final minikube & other containers to make sure that 
# - all expected things are there, networking and everything else works etc
sleep 30 && docker ps
docker exec -it --user docker sarathy-${VERSION}-minikube minikube status
docker exec -it --user docker sarathy-${VERSION}-minikube kubectl get pods -A

docker kill sarathy-${VERSION} sarathy-${VERSION}-minikube

# Push images if asked for
if [[ "${1}" == 'push' ]]; then
    printf "Pushing images to docker registry\n"
    docker push savyasachi9/binaries:${VERSION} && docker push savyasachi9/binaries:latest
    docker push savyasachi9/sarathy:${VERSION} && docker push savyasachi9/sarathy:latest
    docker push savyasachi9/sarathy:${VERSION}-minikube && docker push savyasachi9/sarathy:minikube
fi