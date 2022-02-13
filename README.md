# Sarathy
"one with a chariot"

general purpose tools to build container apps

### Usage
```bash
# Run container with 'minikube' k8s cluster
# credentials: docker / d
docker run -it --rm --privileged \
    -p 9090-9099:9090-9099 \
    -h sarathy --name sarathy \
    -v ${PWD}:/src/user \
    savyasachi9/sarathy:live-amd64

# Connect to container
docker exec -it --user docker sarathy bash

# Visit webtty/gotty with bash in browser (not available for arm64 yet)
http://localhost:9090

# Visit code-server/vscode in browser
http://localhost:9091/?folder=/src/

```
> use image 'savyasachi9/sarathy:live-arm64' for arm64 arch (apple m1, raspberry pi etc)

> *live* in the tag *live-amd64 / live-arm64* means container image has docker, k8s etc already up & running aka live !!!

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
