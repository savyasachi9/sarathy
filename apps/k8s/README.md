### Mysql deploy/delete @ k8s cluster using 'Taskfile'
```bash
app mysql deploy
app mysql test
app mysql delete

# Mysql gets deployed as a NodePort Service so you can access it from sarathy like this
# mysql -h 0.0.0.0 -u root -p root
```

### Redis deploy/delete @ k8s cluster using 'Taskfile'
```bash
app redis deploy
app redis test
app redis delete

# Redis gets deployed as a NodePort Service so you can access it from sarathy like this
# redis-cli -h 0.0.0.0
```