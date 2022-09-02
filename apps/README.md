### Use 'app' cmd to deploy/delete/test/... apps @ k8s cluster using ['task'](https://taskfile.dev/) cmd under the hood
```bash
# apps/k8s/mysql/taskfile.yaml
app mysql deploy
app mysql test
app mysql delete

# apps/k8s/redis/taskfile.yaml
app redis deploy
app redis test
app redis delete
```