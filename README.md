# [**Samba**](https://github.com/chonjay21/docker-samba)
## Samba based on official latest alpine image
* Support Authentication
* Support creation|directory mask change
* Support UserID|GroupID change
* Support custom TimeZone
* Support custom event script override

<br />

Our goal is to create a simple, consistent, customizable and convenient image using official image

Find me at:
* [GitHub](https://github.com/chonjay21)
* [Blog](https://chonjay.tistory.com/)

<br />

# Supported Architectures

The architectures supported by this image are:

| Architecture | Tag |
| :----: | --- |
| x86-64 | latest |
| armhf | arm32v7-latest |

<br />

# Usage

Here are some example snippets to help you get started running a container.

## docker (simple)

```
docker run -e APP_USER_NAME=admin -e APP_USER_PASSWD=admin -e APP_UID=1000 -e APP_GID=1000 -p 137:137 -p 138:138 -p 139:139 -p 445:445 -v /samba/data:/home/samba/data chonjay21/samba
```

## docker

```
docker run \
  -e APP_USER_NAME=admin	\
  -e APP_USER_PASSWD=admin	\
  -e APP_UID=1000	\
  -e APP_GID=1000	\
  -e FORCE_REINIT_CONFIG=false            `#optional` \
  -e APP_CREATE_MASK=0660                 `#optional` \
  -e APP_DIRECTORY_MASK=0770              `#optional` \
  -e TZ=America/Los_Angeles               `#optional` \
  -p 137:137 \
  -p 138:138 \
  -p 139:139 \
  -p 445:445 \
  -v /samba/data:/home/samba/data \
  chonjay21/samba
```


## docker-compose

Compatible with docker-compose v2 schemas. (also compatible with docker-compose v3)

```
version: '2.2'
services:
  samba:
    container_name: samba
    image: chonjay21/samba:latest
    environment:
      - APP_USER_NAME=admin
      - APP_USER_PASSWD=admin
      - APP_UID=1000
      - APP_GID=1000
      - APP_CREATE_MASK=0660          #optional
      - APP_DIRECTORY_MASK=0770       #optional
      - FORCE_REINIT_CONFIG=false     #optional
      - TZ=America/Los_Angeles        #optional
    ports:
      - "137:137"
      - "138:138"
      - "139:139"
      - "445:445"
    volumes:
      - /samba/data:/home/samba/data
```

# Parameters

| Parameter | Function | Optional |
| :---- | --- | :---: |
| `-p 137` | for samba port |  |
| `-p 138` | for samba port |  |
| `-p 139` | for samba port |  |
| `-p 445` | for samba port |  |
| `-e APP_USER_NAME=admin` | for login username |  |
| `-e APP_USER_PASSWD=admin` | for login password |  |
| `-e APP_UID=1000` | for filesystem permission (userid)  |  |
| `-e APP_GID=1000` | for filesystem permission (groupid)  |  |
| `-e APP_CREATE_MASK=0660` | for filesystem file permission mask with samba  | O |
| `-e APP_DIRECTORY_MASK=0770` | for filesystem directory permission mask with samba  | O |
| `-e TZ=America/Los_Angeles` | for timezone  | O |
| `-e FORCE_REINIT_CONFIG=false` | if true, always reinitialize APP_USER_NAME etc ...  | O |
| `-v /home/samba/data` | for data access with this container |  |

<br />

# Event scripts

All of our images are support custom event scripts

| Script | Function |
| :---- | --- |
| `/sources/samba/eventscripts/on_pre_init.sh` | called before initialize container (only for first time) |
| `/sources/samba/eventscripts/on_post_init.sh` | called after initialize container (only for first time) |
| `/sources/samba/eventscripts/on_run.sh` | called before running app (every time) |

You can override these scripts for custom logic
for example, if you don`t want your password exposed by environment variable, you can override on_pre_init.sh in this manner

## Exmaple - on_pre_init.sh
```
#!/usr/bin/env bash
set -e

APP_USER_PASSWD=mysecretpassword    # or you can set password from secret store and get with curl etc ...
```

## 1. Override with volume mount
```
docker run \
  ...
  -v /samba/on_pre_init.sh:/sources/samba/eventscripts/on_pre_init.sh \
  ...
  chonjay21/samba
```

## 2. Override with Dockerfile and build
```
FROM chonjay21/samba:latest
ADD host/on_pre_init.sh /sources/samba/
```

<br />

# License

View [license information](https://github.com/chonjay21/docker-samba/blob/master/LICENSE) of this image.

As with all Docker images, these likely also contain other software which may be under other licenses (such as Bash, etc from the base distribution, along with any direct or indirect dependencies of the primary software being contained).

As for any pre-built image usage, it is the image user's responsibility to ensure that any use of this image complies with any relevant licenses for all software contained within.