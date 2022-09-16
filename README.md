# Sarathy
- general purpose toolchain to build cli, web & container apps using docker & k8s
- low-code, no-code
- minikube in docker, k3s in docker
- various modern CLI & CNCF tools

"one with a chariot"

### arch
```bash
    +----------------------------+ -> c/c++, go, python, php ...
    | lang-tools container (dev) | -> Web IDE @ port 9091
    +----------------------------+ -> Web TTY @ port 9092
                  ^
                  |
    +----------------------------+ -> docker, k8s clusters [minikube/k3s]
    | sarathy container (devops) | -> CNCF & other modern cli tools
    +----------------------------+ -> Web TTY @ port 9090
                  ^
                  |
      +------------------------+
      | host OS running docker |
      +------------------------+
```

### Usage : only pre-req is *Docker Desktop* installed/available on host OS(win/mac/*nix)
```bash
# Run minikube in docker
curl -sfL https://savyasachi9.github.io/sarathy/platform/sarathy.sh | bash -s -- minikube run

# Run k3s in docker
curl -sfL https://savyasachi9.github.io/sarathy/platform/sarathy.sh | bash -s -- k3s run

# Or just run docker in docker
curl -sfL https://savyasachi9.github.io/sarathy/platform/sarathy.sh | bash -s -- latest run

# Visit webtty/gotty with bash in browser (not available for arm64 yet)
http://localhost:9090
```
> support for amd64 & arm64 (apple m1, raspberry pi etc)

> all the tools in container image are installed for user 'docker'

> minikube/k3s images come pre-installed with mysql8.0 and redis6.2 using helm charts

### Programming Languages container
- c/c++, gcc 9, gdb
- golang1.17, dlv
- php8.1, xdebug
- python3.8, pip3

```bash
# You can either run 'sarathy' container to use 'langtools/plt' container or run it like
curl -sfL https://savyasachi9.github.io/sarathy/platform/sarathy.sh | bash -s -- plt run

# Visit code-server/vscode IDE in browser
http://localhost:9091/?folder=/src/

# Visit webtty/gotty with bash in browser (not available for arm64 yet)
http://localhost:9092

# Connect to langtools/plt container
docker exec -it sarathy-plt /bin/bash

# Connect to langtools container thru sarathy-minikube container
docker exec -it --user docker sarathy-minikube /bin/bash -c "docker exec -it langtools bash"
```
> above languages are pre-installed with debug extensions, use key 'F5' to run debugger in IDE

### Tools & Utils
- build-tools
  * [task](https://taskfile.dev) (yaml based build tool / task runner)
- containers
  * docker (docker in docker / dind)
  * [containerd](https://containerd.io/)
  * [podman](https://podman.io/)
  * [ctop](https://ctop.sh/)
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
- Lower the entry bar for to get started with building cli/web/container applications.
- Create a bridge between DEV & DEVOPS along with DEV teams such that they all speak the same language for apps & infra.
- 10+ users by EOY 2022, 100+ by EOY 2023, 1000+ by EOY 2024 ...

### Roadmap : Q1/Q2 2022 / finish MVP with stable version
- build toolchain with cutting edge tools as Dockerimage which has capability to run k8s clusters within a container
- support diff programming languages with code-server IDE to build apps
- publish @ github & dockerhub

### Roadmap : Q3/Q4
- add examples/tutorials on how can one use sarathy to build cli/containers/k8s/web apps
- add examples for diff ci/cd tools (skaffold, tilt, devspace, helm, docker, simple app cmds) using Taskfile
- improve upon toolchain & finish open TODOs
- demos, feedback, improvise & get more users !
- publish sarathy.dev

### Roadmap : Q1 2023 & beyond
- TBD

### Security : The good, bad & ugly to look out for
- Never commit ssh keys & other aws, azure, gcloud keys as part of the docker image (wipe things out from the live image of such sort if there's any).
- Scan Sarathy images for vulnerabilities and keep them to minimal.
- Make sure all the open source tools being added in Sarathy's toolchain are properly vetted/examined.
- For all the open source tools we are using, disable telementary or any other kind of tracking to collect user data/stats etc.
- Use wireguard etc to keep an eye on Sarathy's network activity to ensure no tools are tracking

### Publish, Market, Onboard & Support Users
- to friends and devs for feedback
- at places where folks are looking for getting up & running with k8s locally
- in various online/offline forums wherever people are in need for such a toolchain or can benefit from it
- setup discord channel or something similar to support users issues

### Thank-yous, Credits & References
- Many thanks to all the folks whose open source tools/tutorials are stitched together for building this toolchain.
- Much appreciate the folks who are helping build 'sarathy' with their valuable feedback & immense contributions.
