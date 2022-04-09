### Install below tools & more and part of MVP
- k3s + k3d, kind, k0s, vmware-tanzu, microk8s ?
- devspace
- hugo docs & other docs apps like netifly etc
- image vulnerability scanner
- local image registry

### Cleanups & usage improvements, user examples/samples
- app cmd as alias for task cmd
- add more apps/... besides mysql with varioud ci/cd techs used as examples etc
- build sarathy from root dir & copy over self code into image
- better leverage docker layer cache by splitting _utils.sh into images/scripts/...sh/es i.e multiple files for each toolchain
- docker compose for running sarathy containers ???
- TheAlgorithms as part of examples into latest image
- Skaffold, tilt etc ci/cd tools examples dir copied into k8s image

### Commit running container for end user:
- sarathy run.sh script like we have for k3s such that all is comprised as part of it
- run with while loop such that we docker commit the live image every X secs
- run container if not already running, docker ps | grep sarathy
- docker run .... && while true; do docker commit ...; sleep X; done

### Automated testing for below use-cases
- test that all container tools, k8s tools are working
  echo $PATH
- test that all web tools are working (9090, 9091, 9092, minikube/8080)
- test that all bash completions work
- test that all PLT's are working with debugger (c/cpp, php, python, go)
- that we can save files using vscode on the container & in users mounted dir
- test that we can save updates to vscode themes
- test that we can save code updates under /src /src/examples /src/user /home/docker
/usr/local/go/bin:/usr/local/bin/tools/rust:/home/docker/.krew/bin:/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin
- test that minikube image has mysql, krew, helm etc working

### Next tools to add:
- lazydocker
- wtf cli dashboard
- benchmarking tools this & others :
  https://github.com/sharkdp/hyperfine
  https://github.com/wg/wrk
  https://github.com/trimstray/htrace.sh
- kubecost
- minikube dashboard inside minikube cluster itself
- minikube ingress (nginx/ambassador)

### Monaco editor
- monaco editor with various github algorithms in diff langs & other open source codes
  just like these 2
  https://goplay.tools/
  https://goplay.space/

### Desktop / GUI support
- enable support for cross platform desktop GUI for sarathy docker conatiner

### Misc tools
- https://github.com/nektos/act
- https://github.com/nvbn/thefuck
- https://github.com/nocodb/nocodb
- https://github.com/nextcloud/docker
- https://education.github.com/toolbox
- https://github.com/localstack/localstack
- https://github.com/sqlmapproject/sqlmap
- mitm with kubetap
- https://github.com/docker-mailserver/docker-mailserver

### Misc Items:
- IMP: disable SWAP ?????? test with disabling swap and if it works then just keep it disabled for best performance of k8s cluster
- install bash testing framwwork and run bash tests for what all we need to test
- install & test kube-cost plugin
- Address all open TODOs
- IMP: look into when minikube cert is gonna expire and for how long is it valid for
-      look into if is there a way we can make it valid for more than default time ???
- Test & use docker volumes for end user instructions for /var/lib/docker such that their docker images can be preserved
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
- support k8s version when starting cluster (minikube, k3s etc) via ENV var in systemctl file --kubernetes-version=v1.21.8
- cncf & other tools, utils, cmds etc for docker + k8s
- Automated tests to ensure that all the tools in toolchain + deployed apps on the cluster work fine
- docs are testable such that they can be maintained
  cmd's, url's etc whatever the docs have there should be automated tests to ensure that things work
- build toolchain w/o using gcr.io/k8s-minikube/kicbase
- Support for package VERSIONs based on conf file for x86/arm64 etc
- support toolchain in other flavors too (arch, redhat, alpine etc)
- see if sarathy can run just fine on containerd , podman etc i.e other container engines than just docker