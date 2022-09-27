install_candcpp(){
    # $1 VERSION         (default GNU gdb 9.2)
    # $2 CODE_SERVER_EXT (default no)
    sudo apt -y update && sudo DEBIAN_FRONTEND=noninteractive apt -y -qq install \
    build-essential gdb libncurses5-dev libncursesw5-dev

    if [[ $2 == 'yes' ]]; then code-server --install-extension /tmp/vscode/*.vsix; fi
}

install_php(){
    # $1 VERSION         (default php8.1)
    # $2 CODE_SERVER_EXT (default no)
    VER=${1:-'8.1'}

    sudo DEBIAN_FRONTEND=noninteractive apt install -y -qq software-properties-common && \
    sudo add-apt-repository -y ppa:ondrej/php && \
    sudo apt -y update && \
    sudo DEBIAN_FRONTEND=noninteractive apt -y -qq install php${VER} php${VER}-fpm && \
    sudo update-alternatives --set php /usr/bin/php${VER}; \
    systemctl disable apache2

    if [[ $2 == 'yes' ]]; then
        sudo DEBIAN_FRONTEND=noninteractive apt -y install php${VER}-xdebug;
        code-server --install-extension felixfbecker.php-debug;
    fi
}

install_python(){
    # $1 VERSION         (default python3.8)
    # $2 CODE_SERVER_EXT (default no)
    # NOTE: python3(comes with distro image)
    sudo DEBIAN_FRONTEND=noninteractive apt install --fix-missing -y -qq python3-pip python-is-python3
    if [[ $2 == 'yes' ]]; then code-server --install-extension ms-python.python; fi
}

install_python_tools(){
    pip3 install thefuck
    echo 'eval $(thefuck --alias)' | sudo tee -a /etc/profile.d/_env.sh

    # TODO: sylmink this in it's own path
    # https://graphviz.gitlab.io/download/
    sudo DEBIAN_FRONTEND=noninteractive apt-get install -y graphviz
    pip3 install diagrams
}

install_golang(){
    # $1 VERSION         (default go1.18beta2)
    # $2 CODE_SERVER_EXT (default no)
    # TODO: install non beta version (issue: couldn't get generics constraints package with go1.18 so using beta)
    VER=${1:-'1.18beta2'}

    wget -q -O go.tar.gz https://go.dev/dl/go${VER}.linux-${ARCH}.tar.gz \
    && tar -xf go.tar.gz && mv go /usr/local \
    && go install -v github.com/go-delve/delve/cmd/dlv@latest \
    && go install -v github.com/ramya-rao-a/go-outline@latest \
    && go install -v golang.org/x/tools/gopls@latest \
    && go install -v github.com/uudashr/gopkgs/v2/cmd/gopkgs@latest \
    && go install -v honnef.co/go/tools/cmd/staticcheck@latest

    if [[ $2 == 'yes' ]]; then code-server --install-extension golang.go; fi
}

install_golang_tools(){
    printf "TODO: do me"
}

install_rust(){
    curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -y
    source $HOME/.cargo/env
    # TODO: code-server ext
}

install_rust_tools(){
    # Tools build using rust lang
    TOOLS_PATH=/usr/local/bin/tools/rust && sudo mkdir -p $TOOLS_PATH

    sudo DEBIAN_FRONTEND=noninteractive apt install -y -qq -o Dpkg::Options::="--force-overwrite" \
    bat ripgrep fd-find nmap

    wget -q -O rustscan.deb https://github.com/RustScan/RustScan/releases/download/2.0.1/rustscan_2.0.1_amd64.deb && \
        sudo dpkg -i rustscan.deb

    # Alot of tools still use cat, grep, find etc cmds so let's not replace them yet...
    ln -s $(which batcat) $TOOLS_PATH/bat && \
    ln -s $(which rg) $TOOLS_PATH/rgrep && \
    ln -s $(which fdfind) $TOOLS_PATH/fd && \
    ln -s $(which rustscan) $TOOLS_PATH/netscan && \
    ln -s $(which hyperfine) $TOOLS_PATH
}

install_java(){
    # $1 VERSION         (default openjdk-8)
    # $2 CODE_SERVER_EXT (default no)
    VER=${1:-'8'}
    sudo mkdir -p /usr/share/man/man1 && sudo DEBIAN_FRONTEND=noninteractive apt -y -qq install maven openjdk-${VER}-jdk

    # TODO: code-server extension
}

# install_node(){
# # TODO: node, npm etc
# }

# install_scratch(){
# }
