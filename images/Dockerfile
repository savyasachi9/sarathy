# syntax = docker/dockerfile:1.3-labs
# above syntax declaration is needed for heredoc support in Dockerfile
# https://github.com/kubernetes/minikube/blob/master/deploy/kicbase/Dockerfile
# NOTE: 'sarathy-base' image is for other devs to extend their things upon which itself extends from below
############### sarathy-base ###############
FROM gcr.io/k8s-minikube/kicbase:v0.0.29 as sarathy-base
ARG DEBIAN_FRONTEND=noninteractive
ARG ARCH
ARG ARCH_ALIAS
ARG USER=docker
ARG HOME=/home/docker
WORKDIR /tmp

# We often run into this issue opensure File has unexpected size (X != Y). Mirror sync in progress?
# so let's remove some/all opensuse mirrors (grep -nr opensuse /etc/apt/)
RUN rm -rf /etc/apt/sources.list.d/devel:kubic:libcontainers:stable*
RUN apt -y update && apt -y upgrade && apt install -y -qq \
    sudo bash-completion vim nano \
    htop wget curl telnet iputils-ping lsof jq tree unzip git screen

# TODO: COPY binaries from cache & not download them all the time
# IMP: changing docker socket to unix from fd else things fail when we start the final container w/o a mount -> /var/lib/docker
# NOTE: we are overriding the docker.service file from base image & further enable features we need for docker

RUN sed -i 's/fd:/unix:/g' /lib/systemd/system/docker.service && \
    sed -i "/ExecStart/iExecStartPre=/usr/bin/bash -c 'mv /var/lib/docker/runtimes /var/lib/docker/runtimes-old || true'" \
    /lib/systemd/system/docker.service && mkdir -p /etc/docker && \
    echo '{ "experimental": true, "debug" : false, "features": { "buildkit": true } }' > /etc/docker/daemon.json

# NOTE: 'k3s' cluster's kubelet service fails for 'systemd' @arm64 as cgroupdriver as it uses 'cgroupfs', so defaulting docker to 'cgroupfs'
# TODO: based on runtime OS support for cgroupdriver update /etc/docker/daemon.json before starting docker
#     echo '{ "exec-opts": ["native.cgroupdriver=cgroupfs"], "experimental": true, "debug" : false, "features": { "buildkit": true } }' > /etc/docker/daemon.json

# Copy over all systemd.services
COPY ./images/systemd.services/*.service /etc/systemd/system/
# TODO: use systemd conf file for all related ENV vars instead of making copies for each ARCH etc
COPY ./images/systemd.services/plt.service.${ARCH} /etc/systemd/system/plt.service
COPY ./images/_utils.sh /scripts/install.sh
RUN chmod +x /scripts/install.sh

### Web tools (accessible over http etc):
RUN /bin/bash -c 'source /scripts/install.sh; install_web_tools'; \
    # NOTE: gotty isn't available for arm64 yet so webtty service will fail to start there
    systemctl enable webtty;

### Container & Kubernetes tools (docker, buildah, podman, k8s clusters, plugins, ci/cd tools etc):
ENV PATH="${KREW_ROOT:-$HOME/.krew}/bin:$PATH"
RUN /bin/bash -c 'source /scripts/install.sh; install_container_tools; install_k8s_tools';

### CLI Tools built in diff languages (go, rust, python etc)
ENV PATH="/usr/local/bin/tools/rust:${PATH}"
COPY ./images/scripts/lang-tools.sh /scripts/plt.sh
RUN /bin/bash -c 'source /scripts/plt.sh; install_golang_tools; install_rust_tools'; \
    /bin/bash -c 'source /scripts/plt.sh; install_python; install_python_tools'

### Build, Benchmarking & other misc tools
RUN /bin/bash -c 'source /scripts/install.sh; install_build_tools; install_benchmarking_tools; install_misc_tools'

### Copy apps & set user ENV vars (TODO: use bash_profile ???)
COPY ./apps /src/apps
RUN chown -R $USER:$USER $HOME /scripts && \
    echo "docker:d" | chpasswd && \
    echo "export PATH=${PATH}" >> /etc/profile.d/_env.sh && \
    echo "export TERM=xterm-256color" >> /etc/profile.d/_env.sh && \
    echo "export ARCH=${ARCH}" >> /etc/profile.d/_env.sh && \
    echo "export ARCH_ALIAS=${ARCH_ALIAS}" >> /etc/profile.d/_env.sh && \
    cat /etc/profile.d/k8s.sh >> /etc/profile.d/_env.sh && \
    echo "source /etc/profile.d/_env.sh" >> $HOME/.bashrc && \
    echo "source /scripts/install.sh" >> $HOME/.bashrc && \
    echo "source /src/apps/app.sh" >> $HOME/.bashrc && \
    echo "alias tools='tree /usr/local/bin/tools'" >> $HOME/.bashrc

# TODO: move this up top
COPY ./images/scripts/lang-tools.sh /scripts/lang-tools.sh
#RUN chmod +x /scripts/lang-tools.sh && cat /scripts/lang-tools.sh >> /scripts/install.sh
RUN chmod +x /scripts/lang-tools.sh && \
    echo "source /scripts/lang-tools.sh" >> $HOME/.bashrc

### Cleanups : remove these for now with 'unminimize' msg
RUN rm -rf /usr/local/sbin/unminimize /usr/bin/man /etc/update-motd.d/60-unminimize; \
    rm -rf /tmp/* ~/.ssh/* ~/.docker/*; \
    apt clean && apt autoclean && apt autoremove && apt autoremove --purge -y

WORKDIR /src
###################################
FROM sarathy-base as sarathy-latest

WORKDIR /src
EXPOSE 9090-9099
# TODO: add PLT as a systemd service for the live image