#!/usr/bin/env bash
declare -A IMAGE_TAGS=( [dind]=latest [minikube]=minikube [k3s]=k3s )
image_tags=$(printf "|%s" "${IMAGE_TAGS[@]}")
image_tags="${image_tags:1}"

usage() {
  echo "Usage:
$ ./run.sh ${image_tags}
* param1 <image type flavor>
  "
}

if [[ $1 == '' ]]; then usage; exit 1; fi
# TODO: deduce ARCH automatically and not hardcode to amd64|x86_64
ARCH=amd64
FLAVOR=${IMAGE_TAGS[$1]}
IMAGE=savyasachi9/sarathy:${FLAVOR}-${ARCH}

# Run sarathy if not already running
cnt_id=$(docker ps | grep sarathy-${FLAVOR} | awk '{print $1}')
if [[ "$cnt_id" == '' ]]; then
  cnt_id=$(docker run -it -d --rm --privileged -p 9090-9092:9090-9092 -h sarathy --name sarathy-${FLAVOR} -v ${PWD}:/src ${IMAGE})
fi

printf "Sarathy container is running with id ${cnt_id}\n"
if [[ $FLAVOR != 'plt' ]]; then # TODO: check if FLAVOR in array instead of just 1 val
  printf "\nCheck if docker is running ...\n"
  docker exec $cnt_id /bin/bash -c "systemctl status docker | head -n 3"

  if [[ $FLAVOR != 'latest' ]]; then
    printf "\nCheck if ${FLAVOR} is running ...\n"
    docker exec $cnt_id /bin/bash -c "systemctl status ${FLAVOR} | head -n 3"

    printf "\nCheck if PLT(programming lang tools) is running ...\n"
    docker exec $cnt_id /bin/bash -c "systemctl status plt | head -n 3"
  fi

  printf "
  You can visit below URLs to access sarathy DEVO container via webtty
  http://localhost:9090
  "
fi

printf "
  You can visit below URLs to access sarathy DEV container's IDE(code-server/vscode)
  http://localhost:9091?folder=/src

  You can visit below URLs to access sarathy DEV container via webtty
  http://localhost:9092
"
# docker inspect --format '{{.State.Pid}}' $(docker ps | grep sarathy | awk '{print $1}')