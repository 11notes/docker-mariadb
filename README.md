# docker-mariadb

Dockerfile to create and run your own mariadb process inside an ubuntu docker container.

## docker volumes

/var/lib/mysql

Contains: Your mariadb databases

## docker build
```shell
docker build -t YOURNAME/YOURCONTAINER:YOURTAG .
```
## docker run
```shell
docker run --name mariadb \
    -v volume-db:/var/lib/mysql \
    -d 11notes/mariadb:latest
```

## difference between mariadb:10.4

uid/gid:

```shell
    uid:gid both set to static 1000:1000
```

## build with

* [nginx/alpine:stable](https://github.com/docker-library/mariadb/blob/7384b25a0196d8a7e62173781df5a5bed1eb88d2/10.4/Dockerfile) - official mariadb container

## tips

* [alpine-docker-netshare](https://github.com/11notes/alpine-docker-netshare) - Examples to store persistent storage on NFS/CIFS/etc