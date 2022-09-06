#!/usr/bin/env bash
source ~/.bashrc

if [[ ($1 == 'plt') || ($1 == '') ]]; then
    echo -e "Checking php version"
    php --version

    echo -e "\nChecking go version"
    go version

    echo -e "\nChecking python3 version"
    python3 --version

    echo -e "\nChecking code-server installed extensions"
    code-server --list-extensions
fi

if [[ ($1 == 'k8s') || ($1 == '') ]]; then
    echo -e "\nListing tools"
    tools

    echo -e "\nListing docker images"
    docker images

    echo -e "\nListing, helm stuff, k8s pods ..."
    helm list
    kubectl get pods

    echo -e "\nListing PATH"
    echo $PATH
fi