### Mysql deploy/delete @ k8s cluster using 'Taskfile'
```bash
app mysql deploy
app mysql test
app mysql delete

# from sarathy
# mysql -h 0.0.0.0 -u root -p root
```

### Redis deploy/delete @ k8s cluster using 'Taskfile'
```bash
app redis deploy
app redis test
app redis delete

# from sarathy
# redis-cli -h 0.0.0.0
```