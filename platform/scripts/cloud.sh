#!/usr/bin/env bash

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