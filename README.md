## Interplay Dockerfile


This repository contains a **Dockerfile** of [Interplay](https://iterate.ai/) for integrating startup APIs and enable consumers by having a pay-per-use model.

It sets up [Interplay](https://iterate.ai/) and installs:
- nodejs
- docker
- tesseract
- build-essentials

### Base Docker Image

* [ubuntu:16.04](https://registry.hub.docker.com/u/library/ubuntu/)


### Installation

1. Install [Docker](https://www.docker.com/).

2. Clone this repository and `cd` into it.

    ```bash
    git clone https://github.com/arul329/Test_repo.git

    cd Test_repo
    ```

3. Build the docker image.

    ```bash
    docker build -t="dockerfile/interplay" .
    ```


### Usage

After a successful installation, you can run the docker container and run your interplay instance docker.

```bash
docker run -it dockerfile/interplay
```

#### Data sharing

If you want to share with the container a folder path with data, you can run the following command:

```bash
docker run -it -v <host_path>:<guest_path> dockerfile/interplay
```

For example, if you have some data in `/media/data/files` and you would like it to be accessible in the container in `/data`. You should run:

```bash
docker run -it -v /media/data/files:/data dockerfile/interplay
```

#### The Interplay environment

This Dockerfile will setup a [Interplay Docker environment](https://iterate.ai) with the Interplay dependencies.

Once inside the container, to start using the Interplay Docker run:

```bash
source ./startAll
```

#### Installing more Debian packages

The Dockerfile clears up the `apt` repository index after installing the needed dependencies.

If you want to install more packages, first you have to recreate this index. To do this, run:

```bash
apt-get update
```

#### Notes

Remember to add the `--rm` flag to the `docker run` command if you don't want to store a new container after exiting it. This will save you disk space.

Have a better understanding of the `docker run` command by running:

```bash
docker run --help
```
