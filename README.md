docker-mariadb

Dockerfile to create and run your own mariadb process inside an ubuntu docker container.

## Volumes

/var/lib/mysql

Purpose: MariaDB database storage

## Run
```shell
docker run --name mariadb \
    -v volume-db:/var/lib/mysql \
    -d 11notes/mariadb:latest
```

## Docker -u 1000:1000 (no root initiative)

As part to make containers more secure, this container will not run as root, but as uid:gid 1000:1000.

## Build with
* [mariadb](https://github.com/docker-library/mariadb/blob/7384b25a0196d8a7e62173781df5a5bed1eb88d2/10.4/Dockerfile) - Official MariaDB container

## Tips

* Don't bind to ports < 1024 (requires root), use NAT
* [Permanent Storge with NFS/CIFS/...](https://github.com/11notes/alpine-docker-netshare) - Module to store permanent container data via NFS/CIFS/...