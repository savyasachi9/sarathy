### Cleanups & usage improvements, user examples/samples
- better leverage docker layer cache by splitting _utils.sh into images/scripts/...sh/es i.e multiple files for each toolchain
- add more apps/... besides mysql with varioud ci/cd techs used as examples etc
- TheAlgorithms as part of examples into latest image
- Skaffold, tilt etc ci/cd tools examples dir copied into k8s image
- docs for all/most added tools in sarathy
- docs for skaffold apps showing helm, kustomize etc
- ci/cd for apps for diff ENVs (dev/alpha|qa/beta/prod) with apps for each in diff namepaces with complete isolation

### De-coupling
- have local-registry for sarathy:minikube etc to store images for sarathy:coder and other apps ?
- have sarathy:coder for PLT be downloaded at runtime via it's systemd service & be stored in local-registry ?

### Install below tools & more and part of MVP
- Support multiple ingress's(gloo/nginx/ambassador/kong etc)
- k3s + k3d, kind, k0s (other cluster to consider for later talos k8s linux, vmware-tanzu, microk8s ?)
- hugo docs & other docs apps like mkdocs, mdBook, netifly etc
- logging (stdout/stderr), loki ...
- telemetry metrics, monitoring, alerting (using prometheus)
- stack tracking (jaeger etc)
- open fass, faas
- image vulnerability scanners, https://github.com/snyk/cli etc
- local image registry
- devspace
- rust dog : https://github.com/ogham/dog
- rust LSD
- python diagrams : https://github.com/mingrammer/diagrams

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
- https://github.com/chubin/cheat.sh
- https://github.com/charmbracelet/gum
- lsd / ls cmd modern
- oxide / cd cmd history
- df/du modern alternative duf : https://github.com/muesli/duf
- https://github.com/ogham/exa
- https://github.com/ajeetdsouza/zoxide
- rustscan
- starship
- bore.pub https://github.com/ekzhang/bore
  (ngrok ??? https://github.com/localtunnel/localtunnel ???)
- https://github.com/dokku/dokku
- lazydocker, ctop
- wtf cli dashboard / https://github.com/wtfutil/wtf
- benchmarking tools this & others :
  https://github.com/sharkdp/hyperfine
  https://github.com/wg/wrk
  https://github.com/trimstray/htrace.sh
- kubecost
- minikube dashboard inside minikube cluster itself
- minikube ingress (nginx/ambassador)
- try 'vcluster' ???
- headless CMS/es
- cloud SDKs/CDKs (awscdk, cdktf/terraform)

### Monaco editor
- monaco editor with various github algorithms in diff langs & other open source codes
  just like these 2
  https://goplay.tools/
  https://goplay.space/

### Desktop / GUI support
- enable support for cross platform desktop GUI for sarathy docker conatiner

### Misc tools
- https://github.com/runsidekick/sidekick
- https://github.com/dylanaraps/neofetch/wiki/Installation (colorful sysinfo)
- https://github.com/charmbracelet/bubbletea
- https://github.com/charmbracelet/glow
- https://github.com/nektos/act
- https://github.com/nocodb/nocodb
- https://github.com/nextcloud/docker
- https://education.github.com/toolbox
- https://github.com/dokku/dokku (local heroku)
- https://github.com/localstack/localstack (local aws)
- https://github.com/sqlmapproject/sqlmap
- mitm with kubetap & other such tools like 'bettercap', ettercap etc
- https://github.com/docker-mailserver/docker-mailserver
- https://github.com/meilisearch/meilisearch
- https://github.com/milvus-io/milvus
- https://github.com/zinclabs/zinc
- https://github.com/extrawurst/gitui
- diff nix shells (fish, nushell etc)
- https://github.com/kevwan/tproxy
- https://github.com/pocketbase/pocketbase
- https://dokku.com/docs/deployment/application-deployment
- https://github.com/vi/websocat
- https://github.com/stakater/Reloader

### Security
- https://github.com/trufflesecurity/trufflehog
- https://github.com/wazuh/wazuh
- https://github.com/kubescape/kubescape
- https://github.com/ffuf/ffuf#get-parameter-fuzzing

### Misc Items:
- IMP: disable SWAP ?????? test with disabling swap and if it works then just keep it disabled for best performance of k8s cluster
- install bash testing framework and run bash tests for what all we need to test
- install & test kube-cost plugin
- Address all open TODOs
- IMP: look into when minikube cert is gonna expire and for how long is it valid for
-      look into if is there a way we can make it valid for more than default time ???
- Test & use docker volumes for end user instructions for /var/lib/docker such that their docker images can be preserved
- Instructions for end user to extend sarathy & build their own base/live images
- IPFS support & croc for sending files over web
- Spacedrive : https://github.com/spacedriveapp/spacedrive
- rust-desk
- also test sarathy GUI on linux amd64, win amd64 and mac arm64/amd64
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
- see if sarathy can run just fine on containerd, podman etc i.e other container engines than just docker

### TODO:
- coder image decoupling and tabular info for the image with languages tools etc below it
- mount /src and /home dirs into coder container , make sure nothing in coder's /home is getting overridden
  or should we mount to /root/ ??? hmm maybe just create a user
- maybe we don't need to mount anything except /src/user as everything else for examples etc should be there
  later we'll have more examples too
  idea is to share the IDE between both containers for using examples from both
  both the containers can be used independently especially the coder cont
  k8s container can be used alone or with langtools container running in it
  sooo figure out how to mount the code from sarathy:k8s -> sarathy:coder
  examples/coder or examples/programming is the only dir which is for 'coder cont', only this dir goes into its image
  rest all dirs get mounted from sarathy:minikube -> sarathy:coder

- tools & utils in tabular form too

### TODOs for lang-tools docker image:
- support for 'go live reload' https://github.com/cosmtrek/air

### Phishing tools
https://github.com/htr-tech/nexphisher

### Expose localhost to www
- NGROK (https://ngrok.com)
- SERVEO (https://serveo.net)
- LOCALHOSTRUN (https://localhost.run)
- LOCALXPOSE (https://localxpose.io/)