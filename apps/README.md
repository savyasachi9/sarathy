### Use 'app' cmd to deploy/delete/test apps @ k8s cluster using 'app' cmd using ['task'](https://taskfile.dev/) cmd under the hood
```bash
# mysql
# 'sarathy' container : mysql -h 0.0.0.0 -u root -p root
app mysql deploy
app mysql test
app mysql delete

# redis
# 'sarathy' container : redis-cli -h 0.0.0.0
app redis deploy
app redis test
app redis delete
```