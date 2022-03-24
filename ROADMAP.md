### MVP
- build toolchain as Dockerimage which has capability to run k8s clusters within a container

### TODO: install all listed below and more and part of MVP
- ubuntu 20.04 LTS (Focal Fossa)
- docker, podman
- minikube, k3s + k3d, kind, microk8s ?
- skaffold, kubectl, helm, tilt, devspace, k9s
- bat, starship, and other rust linux bash cmds alternatives for gnu bash cmds
- hugo docs & other docs apps like netifly etc
- image vulnerability scanner
- base image local registry ?

### Next Steps / TODOs:
- Instructions for end user to extend sarathy & build their own base/live images
- IPFS support & croc for sending files over web
- rust-desk
- also test sarathy GUI on linux amd64, win amd64 and mac arm64/amd64
- use Makefile to build ??? or maybe overkill as we just have 1 bash script ??? but we'll need Makefile in general to run tests etc too not just build
- docs / cheatsheet to use all things sarathy
- mount ~/.ssh dir option, also mount bash_history file, this is mustttt
- reduce image size further
- ingress (nginx / ambassador) with sample apps : make this work on node port else we'd need tunneling & port forwarding
- install more dbs and make them all work on node port 
- install/deploy apps using plain helm cmds & other tools like skaffold tilt etc 
- support running base image (sarathy:latest-x86) with diff clusters (k3s, kind, microk8s ...) & not just minikube
   & then run container with above image + export diff images with cluster name -> sarathy:minikube-x86, sarathy:l8s-x86 etc
- support k8s version when starting cluster (minikube, k3s etc) via ENV var in systemctl file --kubernetes-version=v1.21.8
- template for creating systemd services
- cncf & other tools, utils, cmds etc for docker + k8s etc, e.g: krew package manager and some of it's packages
- use volumes instead of mount ??? aka docker volume
- Automated tests to ensure that all the tools in toolchain + deployed apps on the cluster work fine
- docs are testable such that they can be maintained
  cmd's, url's etc whatever the docs have there should be automated tests to ensure that things work
- build toolchain w/o using gcr.io/k8s-minikube/kicbase
- support x86 & arm64 toolchain
- Support for package VERSIONs based on conf file for x86/arm64 etc
- support toolchain in other flavors too (arch, redhat, alpine etc)
- see if sarathy can run just fine on containerd , podman etc i.e other container engines than just docker

### TODO: monaco editor
- monaco editor with various github algorithms in diff langs & other open source codes
  just like these 2
  https://goplay.tools/
  https://goplay.space/

### TODO: rust tools
- https://towardsdatascience.com/awesome-rust-powered-command-line-utilities-b5359c38692
- https://www.makeuseof.com/rust-commands-to-use-in-place-of-linux-commands/

### TODO: misc tools
- https://github.com/nvbn/thefuck
- https://github.com/nocodb/nocodb
- https://github.com/nextcloud/docker
- https://education.github.com/toolbox

### Toolchain info TODO:
- link tools/images/README.md file here instead of polluting this area
- There's different docker images for k8s clusters (minikube, k3s, minrok8s etc).
- Docker images share common tools & utils, e.g: kubectl, helm, kustomize etc cmds are available in all the k8s cluster images.
- For now toolchain is only available in x86 ubuntu based dockerimage.
- To list all the tools & utils you can use cmd 'tools' which'll list available binaries & packages.
  TODO: above cmd 'tools'

### Self Goals
- CKAD cert, try for CKA too
- be proficient at golang
- play with rust and wasm
- switch jobs

### Project Goals:
- 10+ users by EOY 2022, 100+ by EOY 2023, 1000+ by EOY 2024 ... 1/10 users to be Enterprise
- users in 3 categories (students starting grade 6+ -> Masters/PHD, Devs/Tinkerers, Enterprise)
  1 enterprise client to hire 2-3 ENGs & tie ups with schools/colleges/coaching institutes

### Commit running container for end user:
- run with while loop such that we docker commit the live image every X secs
- run container if not already running, docker ps | grep sarathy
- docker run .... && while true; do docker commit ...; sleep X; done

### Security
- NEVER commit ssh keys & other aws, azure, gcloud keys as part of the docker image (wipe things out from the live image of such sort if there's any)

### Publish & Market
- to github in mvp branch for sarathy repo & create PR against master + add DEVs to PR
- to dockerhub with latest & live images
- to friends and devs for feedback
- to various forums

### Projects using sarathy (build on top of)

### Credits & references: