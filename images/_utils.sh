#!/usr/bin/env bash

install_web_tools(){
    TOOLS_PATH=/usr/local/bin/tools/web && sudo mkdir -p $TOOLS_PATH

    if [[ $ARCH == 'amd64' ]]; then \
        # speedtest (TODO: see if this is available for arm64)
        curl -s https://packagecloud.io/install/repositories/ookla/speedtest-cli/script.deb.sh | sudo bash && \
        sudo apt install -y speedtest && ln -s $(which speedtest) $TOOLS_PATH

        # gotty/webtty
        wget -O gotty.tar.gz https://github.com/yudai/gotty/releases/download/v1.0.1/gotty_linux_amd64.tar.gz \
        && tar -xzf gotty.tar.gz && chmod +x gotty && mv gotty /usr/local/bin && ln -s $(which gotty) $TOOLS_PATH
    fi
}

install_web_ides(){
    # code-server/vscode in browser
    VSCODE_EXT_DIR=$HOME/.local/share/code-server/extensions
    VSCODE_SETTINGS_DIR=$HOME/.local/share/code-server/User
    mkdir -p $VSCODE_EXT_DIR $VSCODE_SETTINGS_DIR

    wget -q -O code-server.deb https://github.com/coder/code-server/releases/download/v4.2.0/code-server_4.2.0_${ARCH}.deb \
    && dpkg -i code-server.deb && ln -s $(which code-server) $TOOLS_PATH

    # TODO: move go.toolsManagement to install_go section
    echo '{
    "go.toolsManagement.autoUpdate": false,
    "gopls": {
        "experimentalWorkspaceModule": true,
    },
    "workbench.colorTheme": "Default Dark+",
    "telemetry.telemetryLevel": "off"
}' | tee $VSCODE_SETTINGS_DIR/settings.json
}

install_build_tools(){
    TOOLS_PATH=/usr/local/bin/tools/build-tools && sudo mkdir -p $TOOLS_PATH
    wget -q -O task.deb https://github.com/go-task/task/releases/download/v3.12.0/task_linux_${ARCH}.deb && \
        dpkg -i task.deb && \
        sudo ln -s $(which task) $TOOLS_PATH && \
        sudo ln -s $(which make) $TOOLS_PATH
}

install_benchmarking_tools(){
    TOOLS_PATH=/usr/local/bin/tools/benchmarking && sudo mkdir -p $TOOLS_PATH
    # TODO: move this to rust section & symlink here
    wget -q -O hyperfine.deb https://github.com/sharkdp/hyperfine/releases/download/v1.13.0/hyperfine_1.13.0_${ARCH}.deb \
        && sudo dpkg -i hyperfine.deb && ln -s $(which hyperfine) $TOOLS_PATH
}

install_misc_tools(){
    TOOLS_PATH=/usr/local/bin/tools/misc && sudo mkdir -p $TOOLS_PATH
    sudo apt -y install tldr && tldr ls && ln -s $(which tldr) $TOOLS_PATH
}

install_container_tools(){
    # TODO : add docker & other container related tools, like image vulnerability scanner, dive etc
    # nerdctl(for containerd), buildah if not already there

    TOOLS_PATH=/usr/local/bin/tools/container
    mkdir -p $TOOLS_PATH \
    && ln -s /usr/bin/docker $TOOLS_PATH \
    && ln -s /usr/bin/podman $TOOLS_PATH \
    && ln -s /usr/bin/containerd $TOOLS_PATH

    wget -q -O ctop https://github.com/bcicen/ctop/releases/download/v0.7.7/ctop-0.7.7-linux-${ARCH} \
        && chmod +x ctop && sudo mv ./ctop /usr/local/bin && ln -s $(which ctop) $TOOLS_PATH

    wget -q -O lazydocker.tar.gz https://github.com/jesseduffield/lazydocker/releases/download/v0.12/lazydocker_0.12_Linux_${ARCH_ALIAS}.tar.gz \
        && tar -xzf lazydocker.tar.gz && sudo mv ./lazydocker /usr/local/bin && ln -s $(which lazydocker) $TOOLS_PATH
}

install_k8s_tools(){
    TOOLS_PATH=/usr/local/bin/tools/k8s
    mkdir -p $TOOLS_PATH

    wget -q -O minikube https://storage.googleapis.com/minikube/releases/latest/minikube-linux-${ARCH} \
        && chmod +x minikube && mv minikube /usr/local/bin/

    wget -q -O kubectl "https://dl.k8s.io/release/$(curl -L -s https://dl.k8s.io/release/stable.txt)/bin/linux/${ARCH}/kubectl" \
        && chmod +x kubectl && mv kubectl /usr/local/bin/ && ln -s $(which kubectl) $TOOLS_PATH

    wget -q -O helm.tar.gz https://get.helm.sh/helm-v3.7.2-linux-${ARCH}.tar.gz && tar -xzf helm.tar.gz \
        && chmod +x linux-${ARCH}/helm && mv linux-${ARCH}/helm /usr/local/bin/ && ln -s $(which helm) $TOOLS_PATH

    wget -q -O kustomize.tar.gz https://github.com/kubernetes-sigs/kustomize/releases/download/kustomize%2Fv4.5.4/kustomize_v4.5.4_linux_${ARCH}.tar.gz \
        && tar -xzf kustomize.tar.gz && chmod +x kustomize && mv kustomize /usr/local/bin && ln -s $(which kustomize) $TOOLS_PATH

    curl -Lo skaffold https://storage.googleapis.com/skaffold/releases/latest/skaffold-linux-${ARCH} \
        && chmod +x skaffold && mv skaffold /usr/local/bin/ && ln -s $(which skaffold) $TOOLS_PATH \
        && skaffold config set --global collect-metrics false \
        && skaffold config set --survey --global disable-prompt true

    wget -q -O tilt.tar.gz https://github.com/tilt-dev/tilt/releases/download/v0.23.6/tilt.0.23.6.linux.${ARCH_ALIAS}.tar.gz \
        && tar -xzf tilt.tar.gz && chmod +x tilt && mv tilt /usr/local/bin/ && ln -s $(which tilt) $TOOLS_PATH

    wget -q -O k9s.tar.gz https://github.com/derailed/k9s/releases/download/v0.24.1/k9s_Linux_${ARCH_ALIAS}.tar.gz \
        && tar -xzf k9s.tar.gz k9s && chmod +x k9s && mv k9s /usr/local/bin/ && ln -s $(which k9s) $TOOLS_PATH

    wget -q -O krew.tar.gz https://github.com/kubernetes-sigs/krew/releases/download/v0.4.3/krew-linux_${ARCH}.tar.gz \
        && tar -xzf krew.tar.gz && mv krew-linux_${ARCH} krew && chmod +x krew && mv krew /usr/local/bin/ \
        && ln -s $(which krew) $TOOLS_PATH

    # set kubectl auto-completion & other k8s related aliases etc
    echo "
source <(kubectl completion bash)
alias k=kubectl
complete -F __start_kubectl k
" | tee /etc/profile.d/k8s.sh

}

install_k8s_cluster(){
    # TODO: add support for more than just minikube
    K8S_CLUSTER=${1:-minikube}
    K8S_VERSION=$2
    K8S_DEFAULT_APPS=${3:-'no'}
    # Tools which are added when docker container is up & running
    printf "Adding helm repos\n"

    helm repo add stable https://charts.helm.sh/stable && \
    helm repo add bitnami https://charts.bitnami.com/bitnami && \
    helm repo update

    krew install krew
    kubectl krew install kubectx
    kubectl krew install assert

    # NOTE: this doesn't work with arm64
    # helm repo add kubecost https://kubecost.github.io/cost-analyzer/
    # helm upgrade -i --create-namespace kubecost kubecost/cost-analyzer --namespace kubecost --set kubecostToken="a3ViZWN0bEBrdWJlY29zdC5jb20=xm343yadf98"
    # kubectl krew install cost

    if [[ $K8S_CLUSTER == 'minikube' ]]; then install_k8s_minikube $K8S_VERSION; fi
    if [[ $K8S_CLUSTER == 'k3s' ]]; then install_k8s_k3s $K8S_VERSION; fi
    if [[ $K8S_DEFAULT_APPS == 'yes' ]]; then install_k8s_default_apps; fi

    # some cleanups to save on image size
    if [[ $K8S_CLUSTER != 'minikube' ]]; then sudo rm -rf $(which minikube); fi
    # sudo rm -rf $(which podman)
}

install_k8s_minikube(){
    # Setup k8s minikube cluster with some default components initialized
    if [[ $1 != '' ]]; then sudo sed -i "s/version=/version=${1}/g" /etc/systemd/system/minikube.service; fi

    sudo ln -s /var/run/cri-docker.sock /var/run/cri-dockerd.sock

    sudo systemctl enable minikube
    sudo systemctl start minikube

    # TODO: instead of sleeping here check some other way to save time
    sleep_for=300; printf "Sleeping for ${sleep_for} secs for cluster to boot with all components\n"; sleep ${sleep_for}

    # TODO: ensure minikube cluster is enabled and running
    minikube addons enable metrics-server
    minikube addons enable dashboard

    kubectl wait --for=condition=ready --timeout=300s --all pods

    # TODO: remove these test cmds from here & automate the manual test
    docker images
    kubectl get pods -A
}

install_k8s_k3s(){
    K3S_VERSION='' # default is from stable channel, e.g: v1.23.5+k3s1
    if [[ $1 != '' ]]; then K3S_VERSION="${1}+k3s1"; fi # K8S_VERSION

    # TODO: mount hostpath for node ???
    sudo curl -sLf https://get.k3s.io | \
        INSTALL_K3S_VERSION=${K3S_VERSION} K3S_NODE_NAME='k3s' \
        INSTALL_K3S_EXEC='--disable traefik --disable servicelb --service-node-port-range=80-32767' \
        sh -s - --docker

    sudo chown -R docker /etc/rancher
    echo "export KUBECONFIG=/etc/rancher/k3s/k3s.yaml" | sudo tee -a /etc/profile.d/_env.sh
    source /etc/profile.d/_env.sh

    kubectl wait --for=condition=ready --timeout=300s --all pods
}

install_k8s_default_apps(){
    # Install ingress(nginx/ambassador/gloo etc), redis, mysql etc using helm charts
    # TODO: add support for nginx, redis, mongo etc @ k8s cluster
    source /src/apps/app.sh
    kubectl create namespace dev
    kubectl create namespace alpha

    app mysql deploy
    app mysql install-tools
    app redis deploy
    app redis install-tools
}

install_gcloud_cli(){
    sudo apt-get -y install apt-transport-https ca-certificates gnupg && \
    echo "deb [signed-by=/usr/share/keyrings/cloud.google.gpg] https://packages.cloud.google.com/apt cloud-sdk main" | \
    sudo tee -a /etc/apt/sources.list.d/google-cloud-sdk.list && \
    curl https://packages.cloud.google.com/apt/doc/apt-key.gpg | \
    sudo apt-key --keyring /usr/share/keyrings/cloud.google.gpg add - && \
    sudo apt-get -y update && sudo apt-get -y install google-cloud-cli
}

install_aws_cli(){
    sudo apt install -y awscli
}

install_azure_cli(){
    curl -sL https://aka.ms/InstallAzureCLIDeb | sudo bash
}