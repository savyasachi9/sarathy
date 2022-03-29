#!/usr/bin/env bash

# Install c/c++, gdb, code-server ext
install_candcpp(){
    apt -y update && apt -y -qq install \
    build-essential gdb libncurses5-dev libncursesw5-dev
    code-server --install-extension /tmp/vscode/*.vsix
}

# Install php8.x, composer(TODO:), xdebug, code-server ext
install_php(){
    apt install -y -qq software-properties-common; add-apt-repository -y ppa:ondrej/php; \
    apt -y update && apt -y -qq install php8.1 php8.1-mysql php8.1-xdebug
    systemctl disable apache2
    code-server --install-extension felixfbecker.php-debug
}

# Install python3(comes with distro image), pip3, code-server ext
install_python(){
    apt install -y -qq python3-pip
    code-server --install-extension ms-python.python
}

# TODO: thefuck not working
install_python_tools(){
    printf "TODO: fix me"
    # pip3 install thefuck --user
}

# Install golang with code-server ext
# TODO: install non beta version (issue: couldn't get generics constraints package with go1.18 so using beta)
install_golang(){
    wget -q -O go.tar.gz https://go.dev/dl/go1.18beta2.linux-${ARCH}.tar.gz \
    && tar -xf go.tar.gz && mv go /usr/local \
    && go install -v github.com/go-delve/delve/cmd/dlv@latest \
    && go install -v github.com/ramya-rao-a/go-outline@latest \
    && go install -v golang.org/x/tools/gopls@latest \
    && go install -v github.com/uudashr/gopkgs/v2/cmd/gopkgs@latest \
    && go install -v honnef.co/go/tools/cmd/staticcheck@latest

    code-server --install-extension golang.go
}

install_golang_tools(){
    printf "TODO: do me"
}

# Install rust lang, cargo, code-server ext
install_rust(){
    curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -y
    source $HOME/.cargo/env
    # TODO: code-server ext
}

# Tools build using rust lang
install_rust_tools(){
    TOOLS_PATH=/usr/local/bin/tools/rust
    mkdir -p ${TOOLS_PATH}; \
    apt install -y -qq -o Dpkg::Options::="--force-overwrite" \
    bat ripgrep tldr fd-find; \
    tldr ls; \
    ln -s $(which batcat) ${TOOLS_PATH}/bat && \
    ln -s $(which rg) ${TOOLS_PATH}/rgrep && \
    ln -s $(which tldr) ${TOOLS_PATH}/man && \
    ln -s $(which fdfind) ${TOOLS_PATH}/fd
}

# TODO: rust, java, node npm, ruby???
# install_java(){
# }

# # TODO: node, npm etc
# install_node(){
# }

# install_scratch(){
# }

install_web_tools(){
    TOOLS_PATH=/usr/local/bin/tools/web
    mkdir -p ${TOOLS_PATH}

    if [[ "${ARCH}" = "amd64" ]]; then \
        # speedtest (TODO: see if this is available for arm64)
        curl -s https://install.speedtest.net/app/cli/install.deb.sh | bash; \
        apt-get install speedtest && ln -s $(which speedtest) ${TOOLS_PATH}/speedtest

        # gotty/webtty
        wget -O gotty.tar.gz https://github.com/yudai/gotty/releases/download/v1.0.1/gotty_linux_amd64.tar.gz \
        && tar -xzf gotty.tar.gz && chmod +x gotty && mv gotty /usr/local/bin && ln -s $(which gotty) ${TOOLS_PATH}/gotty
    fi

    # code-server/vscode in browser
    VSCODE_EXT_DIR=$HOME/.local/share/code-server/extensions
    wget -q -O code-server.deb https://github.com/coder/code-server/releases/download/v4.2.0/code-server_4.2.0_${ARCH}.deb \
    && dpkg -i code-server.deb \
    && mkdir -p $VSCODE_EXT_DIR && ln -s $(which code-server) ${TOOLS_PATH}/vscode
}

install_container_tools(){
    TOOLS_PATH=/usr/local/bin/tools/container
    mkdir -p ${TOOLS_PATH} \
    && ln -s /usr/bin/docker ${TOOLS_PATH} \
    && ln -s /usr/bin/podman ${TOOLS_PATH} \
    && ln -s /usr/bin/containerd ${TOOLS_PATH}

    # TODO : add docker & other container related tools, like image vulnerability scanner, dive etc
    # nerdctl(for containerd), buildah if not already there
}

install_k8s_tools(){
    TOOLS_PATH=/usr/local/bin/tools/k8s
    mkdir -p ${TOOLS_PATH}

    wget -q -O minikube https://storage.googleapis.com/minikube/releases/latest/minikube-linux-${ARCH} \
        && chmod +x minikube && mv minikube /usr/local/bin/ && ln -s $(which minikube) ${TOOLS_PATH}/minikube

    wget -q -O kubectl "https://dl.k8s.io/release/$(curl -L -s https://dl.k8s.io/release/stable.txt)/bin/linux/${ARCH}/kubectl" \
        && chmod +x kubectl && mv kubectl /usr/local/bin/ && ln -s $(which kubectl) ${TOOLS_PATH}/kubectl

    wget -q -O helm.tar.gz https://get.helm.sh/helm-v3.7.2-linux-${ARCH}.tar.gz && tar -xzf helm.tar.gz \
        && chmod +x linux-${ARCH}/helm && mv linux-${ARCH}/helm /usr/local/bin/ && ln -s $(which helm) ${TOOLS_PATH}/helm

    # TODO: kustomize (it's already part of kubectl cmd now) ???

    curl -Lo skaffold https://storage.googleapis.com/skaffold/releases/latest/skaffold-linux-${ARCH} \
        && chmod +x skaffold && mv skaffold /usr/local/bin/ && ln -s $(which skaffold) ${TOOLS_PATH}/skaffold

    wget -q -O tilt.tar.gz https://github.com/tilt-dev/tilt/releases/download/v0.23.6/tilt.0.23.6.linux.${ARCH_ALIAS}.tar.gz \
        && tar -xzf tilt.tar.gz && chmod +x tilt && mv tilt /usr/local/bin/ && ln -s $(which tilt) ${TOOLS_PATH}/tilt

    wget -q -O k9s.tar.gz https://github.com/derailed/k9s/releases/download/v0.24.1/k9s_Linux_${ARCH_ALIAS}.tar.gz \
        && tar -xzf k9s.tar.gz k9s && chmod +x k9s && mv k9s /usr/local/bin/ && ln -s $(which k9s) ${TOOLS_PATH}/k9s

    wget -q -O krew.tar.gz https://github.com/kubernetes-sigs/krew/releases/download/v0.4.3/krew-linux_${ARCH}.tar.gz \
        && tar -xzf krew.tar.gz && mv krew-linux_${ARCH} krew && chmod +x krew && mv krew /usr/local/bin/ \
        && ln -s $(which krew) ${TOOLS_PATH}/krew

    # set kubectl auto-completion & other k8s related aliases etc
    echo "
source <(kubectl completion bash)
alias k=kubectl
complete -F __start_kubectl k
" | tee /etc/profile.d/k8s.sh
}

# Setup given k8s cluster with components initialized
# TODO: add support for more than just minikube
install_k8s_cluster(){
    printf "Adding helm repos\n"

    helm repo add stable https://charts.helm.sh/stable && \
    helm repo add bitnami https://charts.bitnami.com/bitnami && \
    helm repo update

    krew install krew
    kubectl krew install kubectx
    kubectl krew install assert

    K8S_CLUSTER="${1:-minikube}"
    if [[ "${K8S_CLUSTER}" == 'minikube' ]]; then
        sudo systemctl enable minikube
        sudo systemctl start minikube

        # TODO: instead of sleeping here check some other way to save time
        sleep_for=180
        printf "Sleeping for ${sleep_for} secs for cluster to boot with all components\n"
        sleep ${sleep_for}

        # TODO: ensure minikube cluster is enabled and running
        minikube addons enable metrics-server
        minikube addons enable dashboard

        kubectl wait --for=condition=ready --timeout=90s --all pods

        # TODO: remove these test cmds from here & automate the manual test
        docker images
        kubectl get pods -A
    else
        printf "Unknown or no cluster name given ()\n"
        return 1
    fi

    # NOTE: this doesn't work with arm64
    # helm repo add kubecost https://kubecost.github.io/cost-analyzer/
    # helm upgrade -i --create-namespace kubecost kubecost/cost-analyzer --namespace kubecost --set kubecostToken="a3ViZWN0bEBrdWJlY29zdC5jb20=xm343yadf98"

    # kubectl krew install cost
}

# Install ingress(nginx/ambassador/gloo etc), redis, mysql etc using helm charts
# TODO: add support for nginx, redis, mongo etc @ k8s cluster
install_k8s_default_apps(){
    NAMESPACE=default
    helm install ${NAMESPACE}-mysql bitnami/mysql \
        --set auth.rootPassword=root --set primary.service.type=NodePort --set primary.service.nodePort=3306

    # Misc to support final live image which has mysql, redis etc installed
    #sudo apt -y install mysql-client redis-tools

    kubectl wait --for=condition=ready --timeout=90s --all pods
}