### MVP
- build toolchain as Dockerimage which has capability to run k8s clusters within a container
- use ubuntu image as base 

### Publish & Market
- to github in mvp branch for sarathy repo & create PR against master + add DEVs to PR
- to dockerhub with latest & live images
- to friends and devs for feedback + help etc
- to various forums

### Credits & references:

### Security
- NEVER commit ssh keys & other gcloud keys as part of the docker image (wipe things out from the live image of such sort)
- ssh keys, gcloud keys & docker creds etc -> before committing the image, docker exec and run cmd to wipe out such keys

### TODO: install all listed below and more and part of MVP
- ubuntu 20.04 LTS (Focal Fossa)
- docker, podman
- minikube, k3s + k3d, kind, microk8s ?
- skaffold, kubectl, helm, tilt, devspace, k9s
- bat, starship, and other rust linux bash cmds alternatives for gnu bash cmds
- hugo docs & other docs apps like netifly etc
- image vulnerability scanner
- base image local registry ?

### Next Steps / TODOs
- docs / cheatsheet to use all things sarathy
- mount ~/.ssh dir option, also mount bash_history file, this is mustttt
- ingress (nginx / ambassador) with sample apps : make this work on node port else we'd need tunneling & port forwarding
- install more dbs and make them all work on node port 
- install/deploy apps using plain helm cmds & other tools like skaffold tilt etc 
- support running base image (sarathy:latest-x86) with diff clusters (k3s, kind, microk8s ...) & not just minikube
   & then run container with above image + export diff images with cluster name -> sarathy:minikube-x86, sarathy:l8s-x86 etc
- support k8s version when starting cluster (minikube, k3s etc) via ENV var in systemctl file --kubernetes-version=v1.21.8
- template for creating systemd services
- cncf & other tools, utils, cmds etc for docker + k8s etc, e.g: krew package manager and some of it's packages
- install rust tools/cmds
- reduce image size further
- use volumes instead of mount ??? aka docker volume
- see if sarathy can run just fine on containerd , podman etc i.e other container engines than just docker
- Support for package VERSIONs based on conf file for x86/arm64 etc
- Automated tests to ensure that all the tools in toolchain + deployed apps on the cluster work fine
- docs are testable such that they can be maintained
  cmd's, url's etc whatever the docs have there should be automated tests to ensure that things work
- support x86 & arm64 toolchain
- support toolchain in other flavors too (arch, redhat, alpine etc)