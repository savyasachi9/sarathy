# Sarathy
"one with a chariot"

general purpose toolchain to build cli, web & container apps

### Usage
```bash
# Run docker in docker
docker run -it --rm --privileged \
    -p 9090-9099:9090-9099 \
    -h sarathy --name sarathy \
    -v ${PWD}:/src/user \
    savyasachi9/sarathy:latest-amd64

# Or run minikube in docker
docker run -it --rm --privileged \
    -p 9090-9099:9090-9099 \
    -h sarathy --name sarathy \
    -v ${PWD}:/src/user \
    savyasachi9/sarathy:minikube-amd64

# Visit webtty/gotty with bash in browser (not available for arm64 yet)
http://localhost:9090

# Visit code-server/vscode in browser
http://localhost:9091/?folder=/src/

# Connect to container
docker exec -it --user docker sarathy bash

# Connect to mysql running in sarathy containers k8s cluster (if using minikube image)
docker exec -it sarathy mysql -h sarathy -u root -proot
```
> use image 'savyasachi9/sarathy:latest-arm64' for arm64 arch (apple m1, raspberry pi etc)

> all the tools in container image are installed for user 'docker'

> login creds : docker / d

### Programming Languages
- c/c++, gcc 9, gdb
- golang1.17, dlv
- php8.1, xdebug
- python3.8, pip3

> above languages are pre-installed with vscode debug extensions, use key 'F5' to run debugger in vscode


### Tools & Utils
```bash
# list of available tools & utils
tools
/usr/local/bin/tools
├── container
│   ├── containerd -> /usr/bin/containerd
│   ├── docker -> /usr/bin/docker
│   └── podman -> /usr/bin/podman
├── k8s
│   ├── helm -> /usr/local/bin/helm
│   ├── k9s -> /usr/local/bin/k9s
│   ├── krew -> /usr/local/bin/krew
│   ├── kubectl -> /usr/local/bin/kubectl
│   ├── minikube -> /usr/local/bin/minikube
│   ├── skaffold -> /usr/local/bin/skaffold
│   └── tilt -> /usr/local/bin/tilt
├── rust
│   ├── bat -> /usr/bin/batcat
│   ├── fd -> /usr/bin/fdfind
│   ├── man -> /usr/bin/tldr
│   └── rgrep -> /usr/bin/rg
└── web
    ├── gotty -> /usr/local/bin/gotty
    ├── speedtest -> /usr/bin/speedtest
    └── vscode -> /usr/bin/code-server
```
