#!/usr/bin/env bash
RED="\e[31m" GREEN="\e[32m" YELLOW="\e[33m" CYAN="\e[36m" ENDCOLOR="\e[0m"
green()  { echo -e "${GREEN}${1}${ENDCOLOR}";}
cyan()   { echo -e "${CYAN}${1}${ENDCOLOR}";}
yellow() { echo -e "${YELLOW}${1}${ENDCOLOR}";}
red()    { echo -e "${RED}${1}${ENDCOLOR}";}

# cat ./platform/run.sh | bash -s -- minikube
# TODO: curl github URL & install using that eg
usage() {
  echo "Usage:
$ ./run.sh dind|minikube|k3s
* param1 <image type flavor>
  "
}

if [[ $1 == '' ]]; then usage; exit 1; fi
# TODO: deduce ARCH automatically and not hardcode to amd64|x86_64

ARCH=amd64; if [[ $(uname -m) == 'arm64' ]]; then ARCH=arm64; fi
FLAVOR=$1;  if [[ $1 == 'dind' ]]; then FLAVOR=latest; fi
IMAGE=savyasachi9/sarathy:${FLAVOR}-${ARCH}
CNT_NAME=sarathy-${FLAVOR}
PORTS='-p 9090-9092:9090-9092'; if [[ "$@" == *"nopo"* ]]; then PORTS=''; fi

# Run sarathy if not already running
CNT_ID=$(docker ps | grep ${CNT_NAME} | awk '{print $1}')
if [[ "$CNT_ID" == '' ]]; then
  printf "Running ${FLAVOR} ...\n"
  CNT_ID=$(docker run -it -d --rm --privileged ${PORTS} -h sarathy --name ${CNT_NAME} -v ${PWD}:/src ${IMAGE})
  sleep 9
fi

if [[ $CNT_ID == "" ]]; then red "failed to run " exit 1; fi
cyan "Sarathy container is running with name(${CNT_NAME}) & id ${CNT_ID}"

# TODO: check if FLAVOR in array instead of just 1 val
if [[ $FLAVOR != 'plt' ]]; then
  cyan "Checking if docker is running ..."
  docker exec $CNT_ID /bin/bash -c "systemctl status docker | head -n 3 | grep Active"

  cyan "\nChecking if ${FLAVOR} is running ..."
  if [[ $FLAVOR == 'minikube' ]]; then
    docker exec --user docker $CNT_ID /bin/bash -c "minikube status | xargs"
  elif [[ $FLAVOR == 'k3s' ]]; then
    docker exec --user docker $CNT_ID /bin/bash -c "k3s kubectl get nodes"
  fi

  if [[ $PORTS != '' ]]; then
    yellow "\nYou can visit below URLs to access sarathy DEVOPS container via webtty"
    printf "http://localhost:9090"
  fi
fi

if [[ $PORTS != '' ]]; then
  yellow "\n\nYou can visit below URLs to access sarathy DEV container's IDE(code-server/vscode) & webtty"
  printf "  http://localhost:9091?folder=/src
    http://localhost:9092\n"
fi
# docker inspect --format '{{.State.Pid}}' $(docker ps | grep sarathy | awk '{print $1}')