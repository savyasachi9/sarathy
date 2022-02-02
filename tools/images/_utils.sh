#!/usr/bin/env bash
# GOAL Ensure that this script is portable across a Dockerfile build or just installing via ubuntu/fedora in general
# TODO: support rpm & other packages beside deb

ARCH=${1}
ARCH_SUPPORTED=('amd64' 'arm64') # arch's we have tested for & verified everything
ARCH_ALIAS=${ARCH}

# set some defaults
if [[ "${ARCH}" == 'amd64' ]]; then ARCH_ALIAS='x86_64'; fi
if [[ ! " ${ARCH_SUPPORTED[*]} " =~ " ${1} " ]]; then
    printf "Invalid ARCH value given, supported arch are amd64/arm64\n"
    exit 1
fi

printf "Building for ARCH($ARCH)/ARCH_ALIAS($ARCH_ALIAS)\n"

# k8s clusters & tools
BIN_PATH=/usr/local/bin/utils/k8s
mkdir -p ${BIN_PATH}
PATH="${BIN_PATH}:${PATH}"

# minikube
wget -q -O minikube https://storage.googleapis.com/minikube/releases/latest/minikube-linux-${ARCH} \
    && chmod +x minikube && mv minikube ${BIN_PATH}

echo "
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
" | tee /etc/systemd/system/minikube.service

# kubectl with bash completion / https://kubernetes.io/docs/tasks/tools/install-kubectl-linux/
wget -q -O kubectl "https://dl.k8s.io/release/$(curl -L -s https://dl.k8s.io/release/stable.txt)/bin/linux/${ARCH}/kubectl" \
    && chmod +x kubectl && mv kubectl ${BIN_PATH}

cat <<EOF >> /etc/profile.d/env.sh
source <(kubectl completion bash)
alias k=kubectl
complete -F __start_kubectl k
EOF

# helm 3
wget -q -O helm.tar.gz https://get.helm.sh/helm-v3.7.2-linux-${ARCH}.tar.gz \
    && tar -xzf helm.tar.gz \
    && chmod +x linux-${ARCH}/helm && mv linux-${ARCH}/helm ${BIN_PATH}

# kustomize TODO:

# skaffold
# TODO: install more cncf tools https://landscape.cncf.io/
curl -Lo skaffold https://storage.googleapis.com/skaffold/releases/latest/skaffold-linux-${ARCH} \
    && chmod +x skaffold && mv skaffold ${BIN_PATH}

# tilt
wget -q -O tilt.tar.gz https://github.com/tilt-dev/tilt/releases/download/v0.23.6/tilt.0.23.6.linux.${ARCH_ALIAS}.tar.gz \
    && tar -xzf tilt.tar.gz && chmod +x tilt && mv tilt ${BIN_PATH}

# k9s
wget -q -O k9s.tar.gz https://github.com/derailed/k9s/releases/download/v0.24.1/k9s_Linux_${ARCH_ALIAS}.tar.gz \
    && tar -xzf k9s.tar.gz k9s && chmod +x k9s && mv k9s ${BIN_PATH}

# TODO: k8s lens

###################
# container tools :
BIN_PATH=/usr/local/bin/utils/docker
mkdir -p ${BIN_PATH}
PATH="${BIN_PATH}:${PATH}"

# TODO : add docker & other container related tools, like image vulnerabulity scanner, dive etc
# nerdctl + containerd, buildah if not already there

### web tools
BIN_PATH=/usr/local/bin/utils/web
mkdir -p ${BIN_PATH}
PATH="${BIN_PATH}:${PATH}"

# gotty (not available for arm64)
if [[ "${ARCH}" == 'amd64' ]]; then
    wget -q -O gotty.tar.gz https://github.com/yudai/gotty/releases/download/v1.0.1/gotty_linux_amd64.tar.gz \
    && tar -xzf gotty.tar.gz && chmod +x gotty && mv gotty ${BIN_PATH};

    echo "
[Unit]
Description=webtty

[Service]
ExecStart=/usr/local/bin/utils/web/gotty -a 0.0.0.0 -p 9090 -w bash
User=docker

[Install]
WantedBy=multi-user.target
" | tee /etc/systemd/system/webtty.service

    systemctl enable webtty
fi

PACKAGES_PATH=/tmp/packages/deb
mkdir -p ${PACKAGES_PATH}

# vscode in browser (code-server)
wget -q -O ${PACKAGES_PATH}/code-server.deb https://github.com/coder/code-server/releases/download/v4.0.1/code-server_4.0.1_${ARCH}.deb
dpkg -i ${PACKAGES_PATH}/code-server.deb

echo "
[Unit]
Description=vscode

[Service]
ExecStart=code-server --auth none --bind-addr 0.0.0.0:9091
User=docker

[Install]
WantedBy=multi-user.target
" | tee /etc/systemd/system/vscode.service
systemctl enable vscode

# TODO: IPFS support
# TODO: croc for sending files over web

# TODO: SMTP support
# TODO: golang support for msgbox & sarathy pkgs

# prepend to file, so PATH is always up top
printf "export PATH=$PATH\n" > /tmp/path
cat /tmp/path /etc/profile.d/env.sh > /tmp/env
mv /tmp/env /etc/profile.d/env.sh