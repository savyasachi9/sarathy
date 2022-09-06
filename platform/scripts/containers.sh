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
