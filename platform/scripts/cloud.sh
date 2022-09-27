install_gcloud_cli(){
    sudo apt-get -y install apt-transport-https ca-certificates gnupg && \
    echo "deb [signed-by=/usr/share/keyrings/cloud.google.gpg] https://packages.cloud.google.com/apt cloud-sdk main" | \
    sudo tee -a /etc/apt/sources.list.d/google-cloud-sdk.list && \
    curl https://packages.cloud.google.com/apt/doc/apt-key.gpg | \
    sudo apt-key --keyring /usr/share/keyrings/cloud.google.gpg add - && \
    sudo apt-get -y update && sudo apt-get -y install google-cloud-cli
}

install_aws_cli(){
    curl "https://awscli.amazonaws.com/awscli-exe-linux-${ARCH_ALIAS_TWO}.zip" -o "awscliv2.zip"
    unzip awscliv2.zip
    sudo ./aws/install
}

install_aws_localstack(){
    python3 -m pip install --user localstack
    sudo mkdir -p /var/lib/localstack
    sudo chown $USER:$USER /var/lib/localstack
    #echo "export PATH=/home/$USER/.local/bin:$PATH" | sudo tee -a /etc/profile.d/_env.sh
}

install_azure_cli(){
    curl -sL https://aka.ms/InstallAzureCLIDeb | sudo bash
}

install_terraform(){
    wget -O tf.zip https://releases.hashicorp.com/terraform/1.2.9/terraform_1.2.9_linux_${ARCH}.zip
    unzip -o tf.zip && sudo mv terraform /usr/local/bin && sudo ln -s /usr/local/bin/terraform /usr/local/bin/tf
}
