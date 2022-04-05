# Sarathy
"one with a chariot"

general purpose toolchain to build cli, web & container apps

### Usage
```bash
# Run docker in docker
docker run -it --rm --privileged \
    -p 9090-9093:9090-9093 \
    -h sarathy --name sarathy \
    -v ${PWD}:/src/user \
    savyasachi9/sarathy:latest-amd64

# Or run minikube in docker
docker run -it --rm --privileged \
    -p 9090-9093:9090-9093 \
    -h sarathy --name sarathy \
    -v ${PWD}:/src/user \
    savyasachi9/sarathy:minikube-amd64

# Visit webtty/gotty with bash in browser (not available for arm64 yet)
http://localhost:9090

# Visit code-server/vscode IDE in browser
http://localhost:9091/?folder=/src/

# Connect to container
docker exec -it --user docker sarathy bash

# Or connect to container via ssh (login creds : docker / d)
ssh docker@$(docker inspect -f '{{range .NetworkSettings.Networks}}{{.IPAddress}}{{end}}' sarathy)

# Connect to mysql running in sarathy containers k8s cluster from host OS (if using minikube image)
docker exec -it --user docker sarathy /bin/bash -c 'mysql -h sarathy -u root -proot'
```
> use image 'savyasachi9/sarathy:latest-arm64' for arm64 arch (apple m1, raspberry pi etc)

> all the tools in container image are installed for user 'docker'

### Programming Languages
- c/c++, gcc 9, gdb
- golang1.17, dlv
- php8.1, xdebug
- python3.8, pip3

> above languages are pre-installed with debug extensions, use key 'F5' to run debugger in IDE


### Tools & Utils
```bash
# list of available tools & utils
tools
/usr/local/bin/tools
├── build-tools
│   └── task
├── container
│   ├── containerd
│   ├── docker
│   └── podman
├── k8s
│   ├── helm
│   ├── k9s
│   ├── krew
│   ├── kubectl
│   ├── kustomize
│   ├── minikube
│   ├── skaffold
│   └── tilt
├── rust
│   ├── bat   -> batcat
│   ├── fd    -> fdfind
│   ├── man   -> tldr
│   └── rgrep -> rg
└── web
    └── code-server
```

### Target Audience
- Students (Grade 6+ ---> PHD)
- Devs, Tinkerers
- Enterprise, Schools, Colleges, Coaching Institutes

### Project Goals
- Help one stay upto date with modern tooling to solve problems & keep experimenting forever.
- Bridge the ever growing gap between enterpeise & academia where academia is behind what's used in enterprise.
- Lower the entry bar for to get started with building cli/container/web applications.
- 10+ users by EOY 2022, 100+ by EOY 2023, 1000+ by EOY 2024 ...

### Thank-yous, Credits & References
- Many thanks to all the folks whose open source tools/tutorials are stitched together for building this toolchain.
- Much appreciate the folks who are helping build 'sarathy' with their valuable feedback & immense contributions.