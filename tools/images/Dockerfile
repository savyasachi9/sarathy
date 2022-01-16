# syntax = docker/dockerfile:1.3-labs
# above syntax declaration is needed for heredoc support in Dockerfile
ARG VERSION='0.0.0'

FROM savyasachi9/binaries:${VERSION} as binaries

# NOTE: this k8s-minikube image is based on Ubuntu 20.04.3 LTS
# https://github.com/kubernetes/minikube/blob/master/deploy/kicbase/Dockerfile
FROM gcr.io/k8s-minikube/kicbase:v0.0.28 as sarathy
WORKDIR /tmp
RUN DEBIAN_FRONTEND=noninteractive apt -y update && apt -y upgrade
RUN apt install -y -qq \
    sudo bash-completion vim bat nano \
    htop wget curl telnet iputils-ping jq tree unzip git screen

# copy over binaries & env.sh from Dockerfile.binaries image
COPY --from=binaries /usr/local/bin/tmp/*  /usr/local/bin
COPY --from=binaries /etc/profile.d/env.sh /etc/profile.d/env.sh

# vscode in browser
# TODO: move this to binaries image and then copy over here
RUN wget -q -O code-server.deb https://github.com/coder/code-server/releases/download/v4.0.1/code-server_4.0.1_amd64.deb \
    && dpkg -i code-server.deb

# enable features we need for docker
RUN mkdir -p /etc/docker \
    && echo '{ "experimental": true, "debug" : false, "features": { "buildkit": true } }' > /etc/docker/daemon.json

RUN cat <<EOF > /etc/systemd/system/minikube.service
[Unit]
Description=minikube
After=docker.service

[Service]
Type=simple
ExecStart=/usr/local/bin/minikube start --driver=none --extra-config=kubeadm.ignore-preflight-errors=SystemVerification
User=docker
Group=docker
StandardOutput=syslog
StandardError=syslog
SyslogIdentifier=minikube

[Install]
WantedBy=multi-user.target
EOF

#RUN systemctl enable minikube

RUN echo "export TERM=xterm-256color" >> /etc/profile.d/env.sh
RUN echo "docker:docker" | chpasswd
RUN echo "source /etc/profile.d/env.sh" >> /home/docker/.bashrc

RUN rm -rf /tmp/* ~/.ssh/* ~/.docker/*
RUN apt clean && apt autoclean && apt autoremove && apt autoremove --purge -y

RUN mkdir -p /scripts
RUN cat <<'EOF' >> /scripts/post_build.sh
#!/usr/bin/env bash

printf "Adding helm repos\n"
helm repo add stable https://charts.helm.sh/stable \
    && helm repo add bitnami https://charts.bitnami.com/bitnami

# TODO: support more clusters here
K8S_CLUSTER="${1:-minikube}"
if [[ "${K8S_CLUSTER}" == 'minikube' ]]; then
    sudo systemctl enable minikube
    sudo systemctl start minikube

    # TODO: instead of sleeping here check some other way to save time
    printf "Sleeping for 60 secs for cluster to boot"
    sleep 60

    # TODO: ensure minikube cluster is enabled and running
    minikube addons enable dashboard && minikube addons enable metrics-server
else
    printf "Unknown or no cluster name given ()\n"
    return 1
fi
EOF
RUN chmod +x /scripts/post_build.sh