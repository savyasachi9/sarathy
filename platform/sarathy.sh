#########################################################################
# This script is for building|running|extending 'Sarathy' platform      #
# tested on linux/mac m1, need to test on windows                       #
# issues:                                                               #
# - k3s failed on thinkpad x1carbon 6 kubuntu                           #
#########################################################################
RED="\e[31m" GREEN="\e[32m" YELLOW="\e[33m" CYAN="\e[36m" ENDCLR="\e[0m"
info()    { echo -e "${CYAN}${1}${ENDCLR}";}
success() { echo -e "${GREEN}${1}${ENDCLR}";}
yellow()  { echo -e "${YELLOW}${1}${ENDCLR}";}
warn()    { echo -e "${YELLOW}${1}${ENDCLR}";}
err()     { echo -e "${RED}${1}${ENDCLR}";}

# cat ./platform/run.sh | bash -s -- minikube
# TODO: curl github URL & install using that eg
usage() {
  echo -e "${CYAN}Usage:${ENDCLR}
$ ./platform.sh <image type flavor> <action type>
* param1 latest|minikube|k3s|plt
* param2 build|run|stop|kill|exec|ssh|extend

# ${CYAN}Use with cat${ENDCLR}
cat ./platform/sarathy.sh | bash -s -- run k3s

# ${CYAN}Use with curl${ENDCLR}
# ${RED}TODO: add url for curl github sarathy.sh and run|extend it etc for end users${ENDCLR}

# ${CYAN}Use with FLAGS for each cmd, e.g:${ENDCLR}
# ./platform/sarathy.sh build minikube --arch=amd64|arm64 --plt
# ./platform/sarathy.sh run minikube --backup
# ./platform/sarathy.sh extend minikube --extend=/path/to/script.sh
  "
}

################
# Set Defaults #
################
SARATHY_FLAVORS=('minikube' 'k3s') # minikube, k3s, kind, k0s, microk8s
ARCH=amd64 # TODO: more ways to deduce if on arm to foolproof
if [[ $(uname -m) == 'arm64' ]]; then ARCH=arm64; fi
FLAVOR=$1
ACTION=$2

# The image user wants to use for run|exec|ssh
# TODO: use better var names for IMAGE, CNT_NAME, PORTS ...
IMAGE=savyasachi9/sarathy:${FLAVOR}-${ARCH}
CNT_NAME=sarathy-${FLAVOR}
PORTS='-p 9090-9092:9090-9092'

#################
# Validate ARGs #
#################
if [[ ($ACTION == '' || $FLAVOR == '') ]]; then usage; exit 1; fi
if [[ ! " ${SARATHY_FLAVORS[*]} " =~ " ${FLAVOR} " ]]; then
    printf "Invalid flavor value given, supported flavors are:\n${SARATHY_FLAVORS[*]}\n"
    exit 1
fi

#################
# Set Overrides #
#################
if [[ "$@" == *"nopo"* ]]; then PORTS=''; fi

# Run sarathy if not already running
run(){
    # docker inspect --format '{{.State.Pid}}' $(docker ps | grep sarathy | awk '{print $1}')
    CNT_ID=$(docker ps | grep ${CNT_NAME} | awk '{print $1}')
    if [[ "$CNT_ID" == '' ]]; then
        info "Running ${FLAVOR} ...\n"
        CNT_ID=$(docker run -it -d --rm --privileged ${PORTS} -h sarathy --name ${CNT_NAME} -v ${PWD}:/src ${IMAGE})
        if [[ $? -gt 0 ]]; then
            err "Unable to start ${CNT_NAME} @ ${CNT_ID}"; exit 1;
        fi

        # give some breather for container to be up and running before we do some runtime checks
        sleep 9
        success "Sarathy is now running ..."
    else
        success "Sarathy is already running ..."
    fi

    # TODO: check if FLAVOR in array instead of just 1 val
    info "Sarathy container is running with name(${CNT_NAME}) & id ${CNT_ID}"
    if [[ $FLAVOR != 'plt' ]]; then
        info "Checking if docker is running in ${CNT_NAME} ..."
        docker exec $CNT_ID /bin/bash -c "systemctl status docker | head -n 3 | grep Active"

        info "\nChecking if ${FLAVOR} is running in ${CNT_NAME} ..."
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
}

stop(){ info "Stopping ${CNT_NAME} ..."; docker kill $CNT_NAME;}
kill(){ info "Nuking ${CNT_NAME} ..."; docker kill $CNT_NAME;}
exec(){ docker exec -it --user docker $CNT_NAME /bin/bash;}

ssh(){
    ssh docker@$(docker inspect -f '{{range .NetworkSettings.Networks}}{{.IPAddress}}{{end}}' $CNT_NAME)
}

extend(){ err "TODO: extend";}

build(){ err "TODO: build";}

############################################
# Call/Run user given ACTION with all ARGs #
############################################
$ACTION "$@"