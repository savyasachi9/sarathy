# Sarathy
- general purpose toolchain to build cli, web & container apps using docker & k8s
- minikube in docker
- k3s in docker
- various modern CLI & CNCF tools

"one with a chariot"

### Usage
```bash
# Run minikube in docker
docker run -it --rm --privileged \
    -p 9090-9093:9090-9093 \
    -h sarathy --name sarathy \
    -v ${PWD}:/src/user \
    savyasachi9/sarathy:minikube-amd64

# Run k3s in docker
docker run -it --rm --privileged \
    -p 9090-9093:9090-9093 \
    -h sarathy --name sarathy \
    -v ${PWD}:/src/user \
    savyasachi9/sarathy:k3s-amd64

# Or just run docker in docker
docker run -it --rm --privileged \
    -p 9090-9093:9090-9093 \
    -h sarathy --name sarathy \
    -v ${PWD}:/src/user \
    savyasachi9/sarathy:latest-amd64

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

> minikube/k3s images come pre-installed with mysql8.0 and redis6.2

### Programming Languages
- c/c++, gcc 9, gdb
- golang1.17, dlv
- php8.1, xdebug
- python3.8, pip3

> above languages are pre-installed with debug extensions, use key 'F5' to run debugger in IDE


### Tools & Utils
# list of available tools & utils
- build-tools
  * [task](https://taskfile.dev) (yaml based build tool / task runner)
- containers
  * containerd
  * docker
  * podman
  * ctop
- kubernetes/k8s
  * [kubectl](https://kubernetes.io/docs/reference/kubectl/) (k8s control tool)
  * [krew](https://krew.sigs.k8s.io/) (kubectl package manager)
  * [kustomize](https://kustomize.io/) (k8s configuration management)
  * [helm](https://github.com/helm/helm) (k8s package manager)
  * [k9s](https://github.com/derailed/k9s) (cli dashboard to manage k8s clusters)
  * [skaffold](https://skaffold.dev/) (ci/cd)
  * [tilt](https://tilt.dev/) (ci/cd)
- misc
  * man   -> [tldr](https://tldr.sh/) (simplified man pages)
- rust
  * bat   -> [batcat](https://github.com/sharkdp/bat) (modern 'cat' cmd clone with colors)
  * fd    -> [fdfind](https://github.com/sharkdp/fd) (simpler & faster 'find' cmd)
  * rgrep -> [rg](https://github.com/BurntSushi/ripgrep) (recursive 'grep' cmd with regex respecting gitignore)
  * [hyperfine](https://github.com/sharkdp/hyperfine) (A command-line benchmarking tool)
- web
  * [code-server](https://github.com/coder/code-server) (vs-code in browser)
  * [gotty](https://github.com/yudai/gotty) (share terminal over http)
  * [speedtest](https://www.speedtest.net/apps/cli) (test internet speed from cli)

### Target Audience
- Students (Grade 6+ ---> PHD)
- Devs, Tinkerers
- Enterprise, Schools, Colleges, Programming/Coding Bootcamps

### Project Goals
- Help one stay upto date with modern tooling to solve problems & keep experimenting forever.
- Bridge the ever growing gap between enterpeise & academia where academia is behind what's used in enterprise.
- Lower the entry bar for to get started with building cli/container/web applications.
- 10+ users by EOY 2022, 100+ by EOY 2023, 1000+ by EOY 2024 ...

### Thank-yous, Credits & References
- Many thanks to all the folks whose open source tools/tutorials are stitched together for building this toolchain.
- Much appreciate the folks who are helping build 'sarathy' with their valuable feedback & immense contributions.