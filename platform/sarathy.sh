#!/usr/bin/env bash
#########################################################################
# This script is for building|running|extending 'Sarathy' platform      #
# tested on linux/mac m1, need to test on windows                       #
# issues:                                                               #
# - k3s failed on thinkpad x1carbon 6 kubuntu                           #
# - ./platform/sarathy.sh minikube ssh (hangs)                          #
#########################################################################
RED="\e[31m" GREEN="\e[32m" YELLOW="\e[33m" CYAN="\e[36m" ENDCLR="\e[0m"
info()    { printf "${CYAN}${1}${ENDCLR}\n";}
success() { printf "${GREEN}${1}${ENDCLR}\n";}
yellow()  { printf "${YELLOW}${1}${ENDCLR}\n";}
warn()    { printf "${YELLOW}${1}${ENDCLR}\n";}
err()     { printf "${RED}${1}${ENDCLR}\n";}

usage() {
  printf "${CYAN}Usage:${ENDCLR}
$ ./platform.sh <image type flavor> <action type>
* param1 latest|minikube|k3s|plt
* param2 build|run|stop|kill|exec|extend

# ${CYAN}Use with cat${ENDCLR}
cat ./platform/sarathy.sh | bash -s -- minikube run

# ${CYAN}Use with curl${ENDCLR}
curl -sfL https://savyasachi9.github.io/sarathy/platform/sarathy.sh | bash -s -- minikube run

# ${RED}TODO: how to extend it etc for end users${ENDCLR}

# ${CYAN}Use with FLAGS for each cmd, e.g:${ENDCLR}
# ./platform/sarathy.sh build minikube --arch=amd64|arm64 --plt
# ./platform/sarathy.sh run minikube --backup
# ./platform/sarathy.sh extend minikube --extend=/path/to/script.sh
\n"
}

####################################
# TODO: add check for if docker    #
# exists on host OS (win/mac/*nix) #
####################################

############################
# Set Default ENV Vars ... #
############################
SARATHY_FLAVORS=('minikube' 'k3s' 'latest' 'plt') # minikube, k3s, kind, k0s, microk8s
ARCH=amd64 # TODO: more ways to deduce if on arm to foolproof
if [[ $(uname -m) == 'arm64' ]]; then ARCH=arm64; fi
FLAVOR=$1
ACTION=$2

#################
# Validate ARGs #
#################
if [[ ($ACTION == '' || $FLAVOR == '') ]]; then usage; exit 1; fi
if [[ ! " ${SARATHY_FLAVORS[*]} " =~ " ${FLAVOR} " ]]; then
    printf "Invalid flavor value given, supported flavors are:\n${SARATHY_FLAVORS[*]}\n"
    exit 1
fi

################################
# Set Overrides & Deduced Vars #
################################
# The image user wants to use for run|exec|ssh
# TODO: use better var names for IMAGE, CNT_NAME, PORTS ...
IMAGE=savyasachi9/sarathy:${FLAVOR}-${ARCH}
CNT_NAME=sarathy-${FLAVOR}
PORTS='-p 9090-9099:9090-9099'
USER='--user docker'
if [[ "$@" == *"nopo"* ]]; then PORTS=''; fi
# TODO: take out this hack by using plt everywhere instead of langtools & plt !!!
if [[ $FLAVOR == 'plt' ]]; then IMAGE=savyasachi9/langtools:${ARCH}; USER=''; fi

# Run sarathy if not already running
run(){
    # docker inspect --format '{{.State.Pid}}' $(docker ps | grep sarathy | awk '{print $1}')
    local cnt_id=$(docker ps | grep ${CNT_NAME} | awk '{print $1}')
    if [[ "$cnt_id" == '' ]]; then
        info "Running ${FLAVOR} ...\n"
        cnt_id=$(docker run -it -d --rm --privileged ${PORTS} -h sarathy --name ${CNT_NAME} -v ${PWD}:/src ${IMAGE})
        if [[ $? -gt 0 ]]; then
            err "Unable to start ${CNT_NAME} @ ${cnt_id}"; exit 1;
        fi

        # give some breather for container to be up and running before we do some runtime checks
        sleep 9
        success "${CNT_NAME} is now running ..."
    else
        success "${CNT_NAME} is already running ..."
    fi

    # TODO: check if FLAVOR in array instead of just 1 val
    info "${CNT_NAME} container is running with id(${cnt_id})"
    if [[ $FLAVOR != 'plt' ]]; then
        info "Checking if docker is running in ${CNT_NAME} ..."
        docker exec $cnt_id /bin/bash -c "systemctl status docker | head -n 3 | grep Active"

        info "\nChecking if ${FLAVOR} is running in ${CNT_NAME} ..."
        if [[ $FLAVOR == 'minikube' ]]; then
            docker exec $USER $cnt_id /bin/bash -c "minikube status | xargs"
        elif [[ $FLAVOR == 'k3s' ]]; then
            docker exec $USER $cnt_id /bin/bash -c "k3s kubectl get nodes"
        fi

        if [[ $PORTS != '' ]]; then
            info "\nYou can visit below URLs to access DEVOPS container via webtty"
            yellow "http://localhost:9090"
        fi
    fi

    if [[ $PORTS != '' ]]; then
        info "\nYou can visit below URLs to access DEV container's IDE(code-server/vscode) & webtty"
        yellow "http://localhost:9091?folder=/src"
        yellow "http://localhost:9092\n"
    fi
}

stop(){ info "Stopping ${CNT_NAME} ..."; docker kill $CNT_NAME;}
kill(){ info "Nuking ${CNT_NAME} ..."; docker kill $CNT_NAME;}
exec(){
    local _exec="docker exec -it $USER $CNT_NAME /bin/bash"
    $_exec
    if [[ $? -gt 0 ]]; then
        err "Unable to exec into container, use below cmd ..."
        info "$_exec"
    fi
}

ssh(){
    ssh docker@$(docker inspect -f '{{range .NetworkSettings.Networks}}{{.IPAddress}}{{end}}' $CNT_NAME)
}

extend(){ err "TODO: extend";}

build(){ err "TODO: build";}

############################################
# Call/Run user given ACTION with all ARGs #
############################################
$ACTION "$@"
