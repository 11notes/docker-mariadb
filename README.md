![banner](https://github.com/11notes/defaults/blob/main/static/img/banner.png?raw=true)

# MARIADB
[<img src="https://img.shields.io/badge/github-source-blue?logo=github&color=040308">](https://github.com/11notes/docker-MARIADB)![5px](https://github.com/11notes/defaults/blob/main/static/img/transparent5x2px.png?raw=true)![size](https://img.shields.io/docker/image-size/11notes/mariadb/11.4.5?color=0eb305)![5px](https://github.com/11notes/defaults/blob/main/static/img/transparent5x2px.png?raw=true)![version](https://img.shields.io/docker/v/11notes/mariadb/11.4.5?color=eb7a09)![5px](https://github.com/11notes/defaults/blob/main/static/img/transparent5x2px.png?raw=true)![pulls](https://img.shields.io/docker/pulls/11notes/mariadb?color=2b75d6)![5px](https://github.com/11notes/defaults/blob/main/static/img/transparent5x2px.png?raw=true)[<img src="https://img.shields.io/github/issues/11notes/docker-MARIADB?color=7842f5">](https://github.com/11notes/docker-MARIADB/issues)![5px](https://github.com/11notes/defaults/blob/main/static/img/transparent5x2px.png?raw=true)![swiss_made](https://img.shields.io/badge/Swiss_Made-FFFFFF?labelColor=FF0000&logo=data:image/svg%2bxml;base64,PHN2ZyB2ZXJzaW9uPSIxIiB3aWR0aD0iNTEyIiBoZWlnaHQ9IjUxMiIgdmlld0JveD0iMCAwIDMyIDMyIiB4bWxucz0iaHR0cDovL3d3dy53My5vcmcvMjAwMC9zdmciPjxwYXRoIGQ9Im0wIDBoMzJ2MzJoLTMyeiIgZmlsbD0iI2YwMCIvPjxwYXRoIGQ9Im0xMyA2aDZ2N2g3djZoLTd2N2gtNnYtN2gtN3YtNmg3eiIgZmlsbD0iI2ZmZiIvPjwvc3ZnPg==)

mariadb as simple and secure as it gets

# SYNOPSIS 📖
**What can I do with this?** This image will run mariadb as mariadb with the database mariadb and the password you set initially. Why so simple? Because 99.9% of all containers that need mariadb, are happy with the default settings, no different dbname, different dbuser, whatever needed. It also adds a simple `backup` command to backup the entire database. This command can be executed on a schedule by using [11notes/cron](https://hub.docker.com/r/11notes/cron) automatically. This image is using [tini-pm](https://github.com/11notes/go-tini-pm) as init to start the database process as well as cmd-socket to execute commands from other containers.

# UNIQUE VALUE PROPOSITION 💶
**Why should I run this image and not the other image(s) that already exist?** Good question! All the other images on the market that do exactly the same don’t do or offer these options:

> [!IMPORTANT]
>* This image runs as 1000:1000 by default, most other images run everything as root
>* This image is created via a secure, pinned CI/CD process and immune to upstream attacks, most other images have upstream dependencies that can be exploited
>* This image contains a proper health check that verifies the app is actually working, most other images have either no health check or only check if a port is open or ping works
>* This image works as read-only, most other images need to write files to the image filesystem
>* This image is a lot smaller than most other images

If you value security, simplicity and the ability to interact with the maintainer and developer of an image. Using my images is a great start in that direction.

# COMPARISON 🏁
Below you find a comparison between this image and the most used or original one.

| **image** | 11notes/mariadb:11.4.5 | mariadb:11.4.5 |
| ---: | :---: | :---: |
| **image size on disk** | 271MB | 327MB |
| **process UID/GID** | 1000/1000 | 0/0 |
| **distroless?** | ❌ | ❌ |
| **rootless?** | ✅ | ❌ |

 
# VOLUMES 📁
* **/mariadb/etc** - Directory of config files
* **/mariadb/var** - Directory of database files
* **/mariadb/backup** - Directory of backups

# COMPOSE ✂️
```yaml
name: "mariadb"
services:
  server:
    image: "11notes/mariadb:11.4.5"
    read_only: true
    environment:
      TZ: "Europe/Zurich"
      MARIADB_PASSWORD: ${MARIADB_PASSWORD}
    volumes:
      - "etc:/mariadb/etc"
      - "var:/mariadb/var"
      - "backup:/mariadb/backup"
      - "cmd:/run/cmd"
    ports:
      - "3306:3306/tcp"
    tmpfs:
      # needed for read-only file system to work
      - "/run/mariadb:uid=1000,gid=1000"
    restart: "always"

  cron:
    depends_on:
      server:
        condition: "service_healthy"
        restart: true
    image: "11notes/cron:4.6"
    environment:
      TZ: "Europe/Zurich"
      # run backup every day at 03:00
      CRONTAB: |-
        0 3 * * * cmd-socket '{"bin":"backup"}' > /proc/1/fd/1
    volumes:
      - "cmd:/run/cmd"
    restart: "always"

volumes:
  etc:
  var:
  cmd:
  backup:
```

# DEFAULT SETTINGS 🗃️
| Parameter | Value | Description |
| --- | --- | --- |
| `user` | docker | user name |
| `uid` | 1000 | [user identifier](https://en.wikipedia.org/wiki/User_identifier) |
| `gid` | 1000 | [group identifier](https://en.wikipedia.org/wiki/Group_identifier) |
| `home` | /mariadb | home directory of user docker |
| `config` | /mariadb/etc/default.cnf | default configuration file |

# ENVIRONMENT 📝
| Parameter | Value | Default |
| --- | --- | --- |
| `TZ` | [Time Zone](https://en.wikipedia.org/wiki/List_of_tz_database_time_zones) | |
| `DEBUG` | Will activate debug option for container image and app (if available) | |
| `MARIADB_PASSWORD` | password for user mariadb |  |

# MAIN TAGS 🏷️
These are the main tags for the image. There is also a tag for each commit and its shorthand sha256 value.

* [11.4.5](https://hub.docker.com/r/11notes/mariadb/tags?name=11.4.5)

### There is no latest tag, what am I supposed to do about updates?
It is of my opinion that the ```:latest``` tag is super dangerous. Many times, I’ve introduced **breaking** changes to my images. This would have messed up everything for some people. If you don’t want to change the tag to the latest [semver](https://semver.org/), simply use the short versions of [semver](https://semver.org/). Instead of using ```:11.4.5``` you can use ```:11``` or ```:11.4```. Since on each new version these tags are updated to the latest version of the software, using them is identical to using ```:latest``` but at least fixed to a major or minor version.

If you still insist on having the bleeding edge release of this app, simply use the ```:rolling``` tag, but be warned! You will get the latest version of the app instantly, regardless of breaking changes or security issues or what so ever. You do this at your own risk!

# REGISTRIES ☁️
```
docker pull 11notes/mariadb:11.4.5
docker pull ghcr.io/11notes/mariadb:11.4.5
docker pull quay.io/11notes/mariadb:11.4.5
```

# SOURCE 💾
* [11notes/mariadb](https://github.com/11notes/docker-MARIADB)

# PARENT IMAGE 🏛️
* [11notes/alpine:stable](https://hub.docker.com/r/11notes/alpine)

# BUILT WITH 🧰
* [mariadb](https://github.com/MariaDB/server)
* [11notes/util](https://github.com/11notes/docker-util)

# GENERAL TIPS 📌
> [!TIP]
>* Use a reverse proxy like Traefik, Nginx, HAproxy to terminate TLS and to protect your endpoints
>* Use Let’s Encrypt DNS-01 challenge to obtain valid SSL certificates for your services

# ElevenNotes™️
This image is provided to you at your own risk. Always make backups before updating an image to a different version. Check the [releases](https://github.com/11notes/docker-mariadb/releases) for breaking changes. If you have any problems with using this image simply raise an [issue](https://github.com/11notes/docker-mariadb/issues), thanks. If you have a question or inputs please create a new [discussion](https://github.com/11notes/docker-mariadb/discussions) instead of an issue. You can find all my other repositories on [github](https://github.com/11notes?tab=repositories).

*created 22.05.2025, 09:08:12 (CET)*