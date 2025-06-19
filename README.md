# lma_amr_ros2_docker_environment

This repository contains a development environment for software development with ROS2 for the LMA laboratory. This should provide a unified and fast setup development environment for its rma.

## Prerequisites

It's expected that the user of this repository already has the following prerequisites installed on their computer:

* A LINUX distribution (although this can work with WSL in Microsoft Windows, it was only tested on Ubuntu and Arch).
* Docker.
* Docker compose.
* Docker buildx (this usually comes with Docker, but may need separate installation on older distributions).
* VSCode (Visual Studio Code) (Although using another IDE and accessing the container via SSH is supported, see [Using another IDE](additional%20docs/Using%20another%20IDE.md)).
* Docker extension for VSCode (Inside VSCode press `ctrl+p` and paste `ext install ms-azuretools.vscode-docker`).
* Dev Container extension for VSCode (Inside VSCode press `ctrl+p` and paste `ext install ms-vscode-remote.remote-containers`).

## Setting up the container

> [!NOTE]
> This steps only need to be executed on the first time.

Everything inside the folder `persistent` will be visible from inside the container and will be persistent across reboots. So in the root of this repository clone the source code as instructed:

```bash
git clone --recurse-submodules -b <branch> <repository url> persistent
```

Replace `<branch>` with the desired branch name and `<repository url>` with the actual repository URL (not to be confused with the site URL).

> [!WARNING]
> This is a container, which means that everything inside of it is transient, this means that if you install a package via terminal, or do any kind of configuration, after a container reboot these changes will be lost.

## Using the container

From VSCode inside the repository root press the key `f1` or `ctrl + shift + p` and run the command:

> [!NOTE]
> The first time that this is run, the entire environment will be downloaded and prepared, this can take a while.

```text
Dev Container: Reopen in Container
```

> [!TIP]
> If Docker is showing a syntax error, it's likely because you're on a system where `buildx` is not the default. To fix this, run the following command to append the necessary environment variables to your `.profile` file:
>
> ```bash
>  echo -e 'export COMPOSE_DOCKER_CLI_BUILD=1\nexport DOCKER_BUILDKIT=1' >> \~/.profile
> ```
>
> Then, reboot your system for the changes to take effect.

### If you apply changes in the container files

This is only necessary if you make any changes in the `Dockerfile` or `compose.yaml`, you'll need to instead run:

```text
Dev Container: Rebuild and Reopen in Container
```

> [!WARNING]
> This should be enough to trigger a rebuild of any file that changed, but docker is a fickle beast and sometimes some cache shenanigans can happen that generate some weird behavior, see [Docker troubleshooting](additional%20docs/Docker%20troubleshooting.md)  to some basic troubleshooting.
