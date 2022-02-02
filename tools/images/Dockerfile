# syntax = docker/dockerfile:1.3-labs
# above syntax declaration is needed for heredoc support in Dockerfile
ARG VERSION='0.0.0'

FROM savyasachi9/binaries:${VERSION} as binaries

# NOTE: this k8s-minikube image is based on Ubuntu 20.04.3 LTS
# https://github.com/kubernetes/minikube/blob/master/deploy/kicbase/Dockerfile
FROM gcr.io/k8s-minikube/kicbase:v0.0.28 as sarathy
WORKDIR /tmp
ARG TARGETARCH

RUN DEBIAN_FRONTEND=noninteractive apt -y update && apt -y upgrade
RUN apt install -y -qq \
    sudo bash-completion vim bat nano \
    htop wget curl telnet iputils-ping jq tree unzip git screen

# copy over binaries & env.sh from Dockerfile.binaries image
COPY ./_utils.sh utils.sh
RUN chmod +x utils.sh && ./utils.sh $TARGETARCH

# IMP:  changing docker docker to unix from fd else things fail when we start the final container w/o a mount -> /var/lib/docker
# NOTE: we are overriding the docker.service file from base image
RUN sed -i 's/fd:/unix:/g' /lib/systemd/system/docker.service

# enable features we need for docker
RUN mkdir -p /etc/docker \
    && echo '{ "experimental": true, "debug" : false, "features": { "buildkit": true } }' > /etc/docker/daemon.json

RUN echo "export TERM=xterm-256color" >> /etc/profile.d/env.sh
RUN echo "docker:docker" | chpasswd
RUN echo "source /etc/profile.d/env.sh" >> /home/docker/.bashrc
# TODO: find some other way todo this
ENV PATH="/usr/local/bin/utils/k8s:/usr/local/bin/utils/docker:/usr/local/bin/utils/web:$PATH"

RUN rm -rf /tmp/* ~/.ssh/* ~/.docker/*
RUN apt clean && apt autoclean && apt autoremove && apt autoremove --purge -y

RUN mkdir -p /scripts
RUN cat <<'EOF' >> /scripts/post_build.sh
#!/usr/bin/env bash
# TODO: find some other way todo this
source /etc/profile.d/env.sh

printf "Adding helm repos\n"
helm repo add stable https://charts.helm.sh/stable \
    && helm repo add bitnami https://charts.bitnami.com/bitnami

# TODO: support more clusters here
K8S_CLUSTER="${1:-minikube}"
if [[ "${K8S_CLUSTER}" == 'minikube' ]]; then
    # TODO: we wanna be k8s cluster agnostic at buildtime and only enable it at runtime ???
    sudo systemctl enable minikube
    sudo systemctl start minikube

    # TODO: instead of sleeping here check some other way to save time
    sleep_for=180
    printf "Sleeping for ${sleep_for} secs for cluster to boot with all components\n"
    sleep ${sleep_for}

    # TODO: ensure minikube cluster is enabled and running
    minikube addons enable metrics-server
    minikube addons enable dashboard
    sleep 30

    # TODO: remove these test cmds from here & automate the manual test
    docker images
    kubectl get pods -A
else
    printf "Unknown or no cluster name given ()\n"
    return 1
fi

# IMP: In the end cleanup docker runtime files else this errors out for next run on another machine
sudo mv /var/lib/docker/runtimes /var/lib/docker/runtimes-old

EOF
RUN chmod +x /scripts/post_build.sh