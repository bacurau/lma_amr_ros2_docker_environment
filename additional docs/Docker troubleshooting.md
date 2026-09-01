# Docker troubleshooting

If you are having unexpected behavior in your container, this can usually be attributed to a cache inconsistency, where docker runs with old images that don't reflect the current files, to solve that, an easy option is to simply rebuild the container without any cache.

> [!WARNING]
> This will trigger a full rebuild the next time the container is run, so it can be very slow, and results can differ when you pull the images and packages from the web.

``` bash
docker compose build --no-cache
```

If that doesn't work you can try cleaning everything docker related from your computer

> [!CAUTION]
> This is a nuclear option, doing this will remove **ALL** images, networks and volumes. Useful [link explaining more about it](https://www.digitalocean.com/community/tutorials/how-to-remove-docker-images-containers-and-volumes)

``` bash
docker system prune --all
```
> [!CAUTION]
> After installing docker desktop, the docker did not work anymore, and even after removing it (https://docs.docker.com/desktop/uninstall/), the docker build still did not work.
> Only do this if you have nothing to lose and do not want do remove docker: remove the ~/.docker folder, this will erase your docker configurations. When you build the docker again it will recreate this folder with the default configurations. I recommend using this only if you have removed everything with prune and it still not worked. This links explains what is the ~/.docker folder: https://docs.docker.com/reference/cli/docker/?utm_source=chatgpt.com. 

``` bash
rm -rf ~/.docker
```


## Debugging the docker image

> [!TIP]
> This is a tip for debugging changes on the dockerfile, using the flag `--progress=plain` allows for the use of the echo command in `RUN`
>
> ``` bash
>   docker buildx build --progress=plain . -t rma_docker:latest
> ```
