# Sarathy
"one with a chariot"

general purpose tools to build container & other web/cli apps

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
/usr/local/bin/utils/
├── containers
│   ├── containerd
│   ├── docker
│   └── podman
├── k8s
│   ├── helm
│   ├── k9s
│   ├── krew
│   ├── kubectl
│   ├── minikube
│   ├── skaffold
│   └── tilt
└── web
    └── gotty
```
