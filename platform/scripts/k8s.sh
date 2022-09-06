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
    source ${APPS_PATH}/app.sh
    kubectl create namespace dev
    kubectl create namespace alpha

    app mysql deploy
    app mysql install-tools
    app redis deploy
    app redis install-tools
}
