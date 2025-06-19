# Using another IDE

If you want to use another IDE, I'll assume that you are a power user, and are more or less on you own.

You will need to uncomment some lines on the `Dockerfile` and `compose.yaml` related to the default user and SSH, everything else including X forwarding should already be set up.

For setting up the container use:

``` bash
docker compose up -d --build
```
