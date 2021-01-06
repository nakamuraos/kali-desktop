# thinhhv / kali-desktop

This repository cloned from https://github.com/lukaszlach/kali-desktop

**Update**:
- Changed docker build image to `kalilinux/kali-rolling` (latest)
- Changed resolution default `1024x576x24` (lower)
- Upgraded `s6-overlay`'s version to `v2.1.0.2`
- Fixed: the image `kali-rolling` missing path `/bin/sh` (this will cause below error)
```bash
# apt-get update
Get:1 http://kali.download/kali kali-rolling InRelease [30.5 kB]
Err:1 http://kali.download/kali kali-rolling InRelease
  Couldn't execute /usr/bin/apt-key to check /var/lib/apt/lists/partial/http.kali.org_kali_dists_kali-rolling_InRelease
Reading package lists... Done
W: GPG error: http://kali.download/kali kali-rolling InRelease: Couldn't execute /usr/bin/apt-key to check /var/lib/apt/lists/partial/http.kali.org_kali_dists_kali-rolling_InRelease
E: The repository 'http://http.kali.org/kali kali-rolling InRelease' is not signed.
N: Updating from such a repository can't be done securely, and is therefore disabled by default.
N: See apt-secure(8) manpage for repository creation and user configuration details.
E: Problem executing scripts APT::Update::Post-Invoke '[ ! -x /usr/bin/debtags ] || debtags update || true'
E: Sub-process returned an error code
```
---

[![Docker pulls](https://img.shields.io/docker/pulls/thinhhv/kali-desktop.svg?label=docker+pulls)](https://hub.docker.com/r/thinhhv/kali-desktop)
[![Docker stars](https://img.shields.io/docker/stars/thinhhv/kali-desktop.svg?label=docker+stars)](https://hub.docker.com/r/thinhhv/kali-desktop)

Kali Desktop provides [Docker images](https://hub.docker.com/r/thinhhv/kali-desktop/) with [Kali Linux](https://www.kali.org/) and a VNC server. This project allows you to pick Kali Linux version, favorite desktop environment, and run it on any system - Linux, MacOS or Windows - to access remotely and execute commands using a VNC client **or a web browser**.

![](https://user-images.githubusercontent.com/5011490/44137821-0af8d0e8-a072-11e8-8962-cd21a1283a04.png)

* Kali Linux latest
    * Xfce - `:xfce`
    * LXDE - `:lxde`
    * KDE - `:kde`
* Kali Linux latest with Top10 tools pre-installed
    * Xfce - `:xfce-top10`

## Running

All required services and dependencies are inside the Docker images so only web browser and one command are needed to start `kali-desktop`:

![](https://user-images.githubusercontent.com/5011490/44146922-0dff2d6c-a092-11e8-875a-2e2ba16dd0bd.gif)

However the most common case is  `kali-desktop` running with host network in privileged mode, so tools like network sniffing work properly and with full speed without Docker network filtering the traffic. See all available Docker image tags on [Docker Hub](https://hub.docker.com/r/thinhhv/kali-desktop/tags/).

```bash
# run on host network
docker run -d --network host --privileged thinhhv/kali-desktop:xfce

# run on Docker network
docker run -d -p 5900:5900 -p 6080:6080 --privileged thinhhv/kali-desktop:xfce
```

After the container is up you can access Kali Linux Desktop under http://localhost:6080, the hostname can differ if you are doing this on a remote server. `vnc_auto.html` will connect you automatically, `vnc.html` allows some connection tuning.

> Docker for Mac works inside a small virtual machine which IP you must use to access the exposed ports or use service like [Dinghy](https://github.com/codekitchen/dinghy).

If you want to customize the container behavior you can pass additional parameters:

```bash
docker run -d \
    --network host --privileged \
    -e RESOLUTION=1280x600x24 \
    -e USER=kali \
    -e PASSWORD=kali \
    -e ROOT_PASSWORD=root \
    -v /home/kali:/home/kali \
    --name kali-desktop \
    thinhhv/kali-desktop:xfce
```

Run parameters:

* `--network host` - optional but recommended, use the host network interfaces, if you do not need to use this option you have to manually publish the ports by passing `-p 5900:5900 -p 6080:6080`
* `--privileged` - optional but recommended
* `-e RESOLUTION` - optional, set streaming resolution and color depth, default `1280x600x24`
* `-e USER` - optional, work as a user with provided name, default `root`
* `-e PASSWORD` - optional, provide a password for USER, default `kali`
* `-e ROOT_PASSWORD` - optional, provide password for root, default `root`
* `-v /home/kali:/home/kali` - optional, if USER was provided it is a good idea to persist user settings, work files and look-and-feel

Exposed ports:

* `5900/tcp` - VNC
* `6080/tcp` - noVNC, web browser VNC client

## Extending

Create `Dockerfile.xfce-web` and modify the image as desired, below example installs Kali Linux web application assessment tools:

```
FROM thinhhv/kali-desktop:xfce

RUN apt-get update && \
    apt-get install -y kali-linux-web \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*
```

Build the image:

```bash
docker build \
    -f Dockerfile.xfce-web \
    -t kali-desktop:xfce-web \
    .
```

Run the image:

```bash
docker run --network host --privileged kali-desktop:xfce-web
```