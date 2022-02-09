# syntax = docker/dockerfile:1.3-labs
# above syntax declaration is needed for heredoc support in Dockerfile

# NOTE: this k8s-minikube image is based on Ubuntu 20.04.3 LTS
# https://github.com/kubernetes/minikube/blob/master/deploy/kicbase/Dockerfile
FROM gcr.io/k8s-minikube/kicbase:v0.0.29 as sarathy
WORKDIR /tmp
#ARG TARGETARCH
ARG ARCH
ARG ARCH_ALIAS
ARG USER=docker
ARG HOME=/home/docker

RUN DEBIAN_FRONTEND=noninteractive apt -y update && apt -y upgrade
RUN apt install -y -qq \
    sudo bash-completion vim bat nano \
    htop wget curl telnet iputils-ping jq tree unzip git screen

# IMP:  changing docker docker to unix from fd else things fail when we start the final container w/o a mount -> /var/lib/docker
# NOTE: we are overriding the docker.service file from base image
# enable features we need for docker
RUN sed -i 's/fd:/unix:/g' /lib/systemd/system/docker.service && \
    sed -i "/ExecStart/iExecStartPre=/usr/bin/bash -c 'mv /var/lib/docker/runtimes /var/lib/docker/runtimes-old || true'" /lib/systemd/system/docker.service && \
    mkdir -p /etc/docker && \
    echo '{ "experimental": true, "debug" : false, "features": { "buildkit": true } }' > /etc/docker/daemon.json

###################################
# Programming Language/s, IDE etc :
# vscode in browser (code-server)
ENV VSCODE_EXT_DIR=$HOME/.local/share/code-server/extensions
RUN wget -q -O code-server.deb https://github.com/coder/code-server/releases/download/v4.0.1/code-server_4.0.1_${ARCH}.deb \
    && dpkg -i code-server.deb \
    && mkdir -p $VSCODE_EXT_DIR

RUN cat <<EOF > /etc/systemd/system/vscode.service && systemctl enable vscode
[Unit]
Description=vscode

[Service]
ExecStart=code-server --auth none --bind-addr 0.0.0.0:9091
User=docker

[Install]
WantedBy=multi-user.target
EOF

# code-server python extension
RUN apt install -y -qq python3-pip; \
    code-server --install-extension ms-python.python

# Build tools for c, c++, make etc
RUN apt install -y -qq \
    build-essential libncurses5-dev libncursesw5-dev gdb

# copy vscode c/c++ extension which works with code-server too
COPY ./vscode/extensions-${ARCH} $VSCODE_EXT_DIR

# php8.1 with xdebug & code-server extension
RUN apt install -y -qq \
    software-properties-common; \
    add-apt-repository ppa:ondrej/php; \
    apt install -y -qq \
    php8.1 php8.1-mysql php8.1-xdebug; \
    code-server --install-extension felixfbecker.php-debug

# Install golang 1.17.6 with code-server extension
ENV PATH="${PATH}:/usr/local/go/bin"
RUN wget -q -O go.tar.gz https://go.dev/dl/go1.17.6.linux-${ARCH}.tar.gz \
    && tar -xf go.tar.gz && mv go /usr/local \
    && code-server --install-extension golang.go \
    && go install -v github.com/go-delve/delve/cmd/dlv@latest \
    && go install -v github.com/ramya-rao-a/go-outline@latest \
    && go install -v golang.org/x/tools/gopls@latest \
    && go env -w GO111MODULE=off

# TODO: rust, java, node npm, ruby???
# rust lang
# RUN curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -y
# source $HOME/.cargo/env

# Install binaries, packages
##########################################
# kubernetes tools (clusters, ci/cd etc) :
ENV BIN_PATH=/usr/local/bin/utils/k8s \
    PATH="${BIN_PATH}:${PATH}" \
    PATH="${KREW_ROOT:-$HOME/.krew}/bin:$PATH"

RUN mkdir -p ${BIN_PATH}; \
    wget -q -O minikube https://storage.googleapis.com/minikube/releases/latest/minikube-linux-${ARCH} \
        && chmod +x minikube && mv minikube ${BIN_PATH}; \

    wget -q -O kubectl "https://dl.k8s.io/release/$(curl -L -s https://dl.k8s.io/release/stable.txt)/bin/linux/${ARCH}/kubectl" \
        && chmod +x kubectl && mv kubectl ${BIN_PATH}; \

    wget -q -O helm.tar.gz https://get.helm.sh/helm-v3.7.2-linux-${ARCH}.tar.gz \
        && tar -xzf helm.tar.gz && chmod +x linux-${ARCH}/helm && mv linux-${ARCH}/helm ${BIN_PATH}; \
    # TODO: kustomize ???
    curl -Lo skaffold https://storage.googleapis.com/skaffold/releases/latest/skaffold-linux-${ARCH} \
        && chmod +x skaffold && mv skaffold ${BIN_PATH}; \

    wget -q -O tilt.tar.gz https://github.com/tilt-dev/tilt/releases/download/v0.23.6/tilt.0.23.6.linux.${ARCH_ALIAS}.tar.gz \
        && tar -xzf tilt.tar.gz && chmod +x tilt && mv tilt ${BIN_PATH}; \

    wget -q -O k9s.tar.gz https://github.com/derailed/k9s/releases/download/v0.24.1/k9s_Linux_${ARCH_ALIAS}.tar.gz \
        && tar -xzf k9s.tar.gz k9s && chmod +x k9s && mv k9s ${BIN_PATH}; \

    wget -q -O krew.tar.gz https://github.com/kubernetes-sigs/krew/releases/download/v0.4.3/krew-linux_${ARCH}.tar.gz \
        && tar -xzf krew.tar.gz && mv krew-linux_${ARCH} krew && chmod +x krew && mv krew ${BIN_PATH}

# minikube service
# TODO: this should rather be k8s cluster service agnostic of type
RUN cat <<EOF > /etc/systemd/system/minikube.service
[Unit]
Description=minikube
After=docker.service

[Service]
Type=simple
ExecStart=/usr/local/bin/utils/k8s/minikube start --driver=none --extra-config=kubeadm.ignore-preflight-errors=SystemVerification
User=docker
Group=docker

[Install]
WantedBy=multi-user.target
EOF

# TODO: k3s servcie, kind service ???

# set kubectl auto-completion & other k8s related aliases etc
RUN cat <<EOF >> /etc/profile.d/k8s.sh
source <(kubectl completion bash)
alias k=kubectl
complete -F __start_kubectl k
EOF

#################################################
# Container tools (docker, buildah, podman etc) :
ENV BIN_PATH=/usr/local/bin/utils/container \
    PATH="${BIN_PATH}:${PATH}"

RUN mkdir -p ${BIN_PATH} \
    && ln -s /usr/bin/docker ${BIN_PATH} \
    && ln -s /usr/bin/podman ${BIN_PATH} \
    && ln -s /usr/bin/containerd ${BIN_PATH}

# TODO : add docker & other container related tools, like image vulnerability scanner, dive etc
# nerdctl + containerd, buildah if not already there
# TODO: link bin aliases for the tools which are there (podman , buildkit etc)

########################################
# Web tools (accessible over http etc) :
ENV BIN_PATH=/usr/local/bin/utils/web \
    PATH="${BIN_PATH}:${PATH}"

# gotty/webtty
RUN mkdir -p ${BIN_PATH}; \
    wget -O gotty.tar.gz https://github.com/yudai/gotty/releases/download/v1.0.1/gotty_linux_amd64.tar.gz \
    && tar -xzf gotty.tar.gz && chmod +x gotty && mv gotty ${BIN_PATH};

# NOTE: gotty isn't available for arm64 yet so only enabling it for amd64
RUN cat <<EOF > /etc/systemd/system/webtty.service && if [ "${ARCH}" = "amd64" ]; then systemctl enable webtty; fi
[Unit]
Description=webtty

[Service]
ExecStart=/usr/local/bin/utils/web/gotty -a 0.0.0.0 -p 9090 -w bash
User=docker

[Install]
WantedBy=multi-user.target
EOF

# TODO: IPFS support & croc for sending files over web

# Set user ENV vars
RUN \
    chown -R $USER $HOME && \
    #echo "${USER}:${USER}" | chpasswd && \
    echo "docker:d" | chpasswd && \
    echo "export TERM=xterm-256color" >> /etc/profile.d/env.sh && \
    echo "export PATH=${PATH}" >> /etc/profile.d/env.sh && \
    cat /etc/profile.d/k8s.sh >> /etc/profile.d/env.sh && \
    # TODO: use bash_profile ???
    echo "source /etc/profile.d/env.sh" >> /home/docker/.bashrc

# remove these for now with 'unminimize' msg
RUN rm -rf /usr/local/sbin/unminimize /usr/bin/man /etc/update-motd.d/60-unminimize; \
    rm -rf /tmp/* ~/.ssh/* ~/.docker/*; \
    apt clean && apt autoclean && apt autoremove && apt autoremove --purge -y

RUN mkdir -p /src/.vscode /src/examples /src/user && chown -R docker:docker /src
COPY ./examples /src/examples
# TODO: check if these settings will work for arm64 outta box or not(if not then only do them for amd64 for now)
# TODO: copy over vscode mscpp extension for both amd64 & arm64 and then install it at buildtime
# TODO: check if zipping extension dir saves and space after docker image is built
COPY ./vscode/.vscode /src/.vscode
WORKDIR /src

RUN mkdir -p /scripts
RUN cat <<'EOF' >> /scripts/post_build.sh
#!/usr/bin/env bash
# TODO: find some other way todo this
source /etc/profile.d/env.sh

printf "Adding helm repos\n"
helm repo add stable https://charts.helm.sh/stable \
    && helm repo add bitnami https://charts.bitnami.com/bitnami

krew install krew
kubectl krew install kubectx
kubectl krew install assert

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

EOF
RUN chmod +x /scripts/post_build.sh