# syntax = docker/dockerfile:1.3-labs
# above syntax declaration is needed for heredoc support in Dockerfile

# NOTE: 'sarathy-base' image is for other devs to extend their things upon which itself extends from below
# https://github.com/kubernetes/minikube/blob/master/deploy/kicbase/Dockerfile
##################################
FROM gcr.io/k8s-minikube/kicbase:v0.0.29 as sarathy-base
WORKDIR /tmp
ARG ARCH
ARG ARCH_ALIAS
ARG USER=docker
ARG HOME=/home/docker

RUN DEBIAN_FRONTEND=noninteractive apt -y update && apt -y upgrade
RUN apt -y update && apt install -y -qq \
    sudo bash-completion vim nano \
    htop wget curl telnet iputils-ping lsof jq tree unzip git screen

# IMP: changing docker socket to unix from fd else things fail when we start the final container w/o a mount -> /var/lib/docker
# NOTE: we are overriding the docker.service file from base image & further enable features we need for docker
RUN sed -i 's/fd:/unix:/g' /lib/systemd/system/docker.service && \
    sed -i "/ExecStart/iExecStartPre=/usr/bin/bash -c 'mv /var/lib/docker/runtimes /var/lib/docker/runtimes-old || true'" /lib/systemd/system/docker.service && \
    mkdir -p /etc/docker && \
    echo '{ "experimental": true, "debug" : false, "features": { "buildkit": true } }' > /etc/docker/daemon.json

# Copy over all systemd.services
COPY ./systemd.services/* /etc/systemd/system/
COPY ./_utils.sh /scripts/
RUN chmod +x /scripts/_utils.sh

### Web tools (accessible over http etc):
RUN /bin/bash -c 'source /scripts/_utils.sh; install_web_tools'; \
    # NOTE: gotty isn't available for arm64 yet so webtty service will fail to start there
    systemctl enable webtty; systemctl enable vscode

### Container tools (docker, buildah, podman, k8s clusters etc) :
RUN /bin/bash -c 'source /scripts/_utils.sh; install_container_tools';

### Kubernetes tools (k8s clusters, plugins, ci/cd tools etc) :
ENV PATH="${KREW_ROOT:-$HOME/.krew}/bin:$PATH"
RUN /bin/bash -c 'source /scripts/_utils.sh; install_k8s_tools';

### Golang tools
RUN /bin/bash -c 'source /scripts/_utils.sh; install_golang_tools'

### Rust tools (binaries, packages built in rustlang)
ENV PATH="/usr/local/bin/tools/rust:${PATH}"
RUN /bin/bash -c 'source /scripts/_utils.sh; install_rust_tools'

### Python tools (binaries, packages built in python)
RUN /bin/bash -c 'source /scripts/_utils.sh; install_python_tools'

### Set user ENV vars (TODO: use bash_profile ???)
RUN chown -R $USER $HOME && \
    echo "docker:d" | chpasswd && \
    echo "export PATH=${PATH}" >> /etc/profile.d/_env.sh && \
    echo "export TERM=xterm-256color" >> /etc/profile.d/_env.sh && \
    cat /etc/profile.d/k8s.sh >> /etc/profile.d/_env.sh && \
    echo "source /etc/profile.d/_env.sh" >> $HOME/.bashrc && \
    echo "source /scripts/_utils.sh" >> $HOME/.bashrc && \
    echo "alias tools='tree /usr/local/bin/tools'" >> $HOME/.bashrc

### Cleanups : remove these for now with 'unminimize' msg
RUN rm -rf /usr/local/sbin/unminimize /usr/bin/man /etc/update-motd.d/60-unminimize; \
    rm -rf /tmp/* ~/.ssh/* ~/.docker/*; \
    apt clean && apt autoclean && apt autoremove && apt autoremove --purge -y

### Post Build steps for FINAL live image
RUN cat <<'EOF' >> /scripts/post_build.sh && chmod +x /scripts/post_build.sh
#!/usr/bin/env bash
source /scripts/_utils.sh
if [[ "${3}" != "" ]]; then sudo sed -i "s/version=/version=${3}/g" /etc/systemd/system/minikube.service; fi
install_k8s_cluster $1
if [[ "${2}" == "yes" ]]; then install_k8s_default_apps; fi
EOF

##################################
FROM sarathy-base as sarathy-latest
# INFO: we ship the sarathy-latest image with PLT (prog lang tools)

### Programming Language/s, vscode/code-server IDE plugins etc :
WORKDIR /tmp
RUN mkdir -p /tmp/vscode /scripts /src/.vscode /src/examples /src/user

COPY ./vscode/extensions-${ARCH} /tmp/vscode
COPY ./vscode/.vscode /src/.vscode
COPY ./examples /src/examples

ENV PATH="/usr/local/go/bin:${PATH}"
RUN /bin/bash -c 'source /scripts/_utils.sh; install_candcpp; install_php; install_python; install_golang'; \
    systemctl enable html-server

RUN chown -R $USER $HOME /src; \
    sed -i '/export PATH/d' /etc/profile.d/_env.sh && echo "export PATH=${PATH}" >> /etc/profile.d/_env.sh

WORKDIR /src