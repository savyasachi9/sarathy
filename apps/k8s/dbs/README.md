### Mysql deploy/delete @ k8s cluster using 'Taskfile'
```bash
task -t apps/k8s/dbs/mysql.yaml deploy
task -t apps/k8s/dbs/mysql.yaml test
task -t apps/k8s/dbs/mysql.yaml delete

# Mysql gets deployed as a NodePort Service so you can access it from sarathy like this
# mysql -h 0.0.0.0 -u root -p root
```

### Redis deploy/delete @ k8s cluster using 'Taskfile'
```bash
task -t apps/k8s/dbs/redis.yaml deploy
task -t apps/k8s/dbs/redis.yaml test
task -t apps/k8s/dbs/redis.yaml delete

# Redis gets deployed as a NodePort Service so you can access it from sarathy like this
# redis-cli -h 0.0.0.0
```