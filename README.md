Netkit in Docker
================

```shell
docker build -t netkit .
docker run --rm -it -p 8022:22 -v /dev/shm --tmpfs /dev/shm:rw,nosuid,nodev,exec,size=4g netkit
ssh -Y -p 8022 root@localhost
```

