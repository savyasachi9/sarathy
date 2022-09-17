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

    if [[ $ARCH == 'arm64' ]]; then \
        wget -O ttyd https://github.com/tsl0922/ttyd/releases/download/1.7.1/ttyd.aarch64 \
        && chmod +x ttyd && mv ttyd /usr/local/bin && ln -s $(which ttyd) $TOOLS_PATH
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
    # "gopls": {
    #     "experimentalWorkspaceModule": true,
    # },
    echo '{
    "go.toolsManagement.autoUpdate": false,
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
