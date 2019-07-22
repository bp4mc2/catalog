# Docker installs

## Prerequisite
Install docker-for-windows or docker-for-mac

## NginX

### Building the container
From the root directory of this repository, execute:

```
cd docker/nginx
docker build -t bp4mc2-nginx .
```

### Running the container
Execute:

```
docker run --detach --publish=8888:80 --name=webserver bp4mc2-nginx
```

The NginX webserver will now be available at http://localhost:8888

If you want the webserver to be available on another port, change the `8888` setting in the execution command above. You'll have to remove the container first (see below).

### Showing logs
Execute:

```
docker logs webserver -f
```

Ommit the `-f` if you don't want to follow the log. Use CTRL-C to stop following.

### Stopping, (re)starting and removing the container

```
docker stop webserver
docker start webserver
docker container rm webserver
```

## DotWebStack

### Building the container
From the root directory of this repository, execute:

```
cd docker/dotwebstack
docker build -t bp4mc2-dws .
```

### Running the container
Execute:

```
docker run --detach --publish=8080:8080 --name=dotwebstack bp4mc2-dws
```

The DotWebStack server will now be available at http://localhost:8080

If you want the webserver to be available on another port, change the first `8080` setting in the execution command above. You'll have to remove the container first (see below).

### Showing logs

Execute:
```
docker logs dotwebstack -f
```

Ommit the `-f` if you don't want to follow the log. Use CTRL-C to stop following.

### Stopping, (re)starting and removing the container

```
docker stop dotwebstack
docker start dotwebstack
docker container rm dotwebstack
```
