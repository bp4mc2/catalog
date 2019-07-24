# Docker installation

## Prerequisite
Install [docker-for-windows](https://download.docker.com/win/stable/Docker%20for%20Windows%20Installer.exe) or [docker-for-mac](https://download.docker.com/mac/stable/Docker.dmg). More information can be found at [Installing Docker Desktop for Windows](https://docs.docker.com/docker-for-windows/install) or [Installing Docker Desktop for Mac](https://docs.docker.com/docker-for-mac/install).

Download and unzip the sources from this repository: https://github.com/bp4mc2/catalog/archive/master.zip

**OR** use git and make a clone: `git@github.com:bp4mc2/catalog.git`

## Networking
The networking configuration uses the simple host.docker.internal DNS entry which is only available in Docker Desktop. This means that the current configuration will not work in a production environment. Changes should be made to:

- /ldt/WEB-INF/resources/apps/ldt/config.xml
- dotwebstack configuration
- nginx configuration

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
docker run --detach --publish=8081:8080 --name=dotwebstack bp4mc2-dws
```

The DotWebStack server will now be available at http://localhost:8081

If you want the webserver to be available on another port, change the `8081` setting in the execution command above. You'll have to remove the container first (see below).

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

## Linked Data theatre

### Building the container
From the root directory of this repository, execute:

```
cd docker/ldt
docker build -t bp4mc2-ldt .
```

### Running the container
Execute:

```
docker run --detach --publish=8080:8080 --name=ldt bp4mc2-ldt
```

The Linked Data Theatre server will now be available at http://localhost:8080

If you want the webserver to be available on another port, change the first `8080` setting in the execution command above. You'll have to remove the container first (see below).

### Showing logs

Execute:
```
docker logs ldt -f
```

Ommit the `-f` if you don't want to follow the log. Use CTRL-C to stop following.

### Stopping, (re)starting and removing the container

```
docker stop ldt
docker start ldt
docker container rm ldt
```

## Fuseki

Per default, fuseki restricts the management console to localhost. This restriction is disabled in this configuration. You can change this by editing the shiro.ini file.

### Building the container
From the root directory of this repository, execute:

```
cd docker/fuseki
docker build -t bp4mc2-fuseki .
```

### Running the container
Execute:

```
docker run --detach --publish=3030:3030 --name=fuseki bp4mc2-fuseki
```

The Linked Data Theatre server will now be available at http://localhost:3030

If you want the webserver to be available on another port, change the first `3030` setting in the execution command above. You'll have to remove the container first (see below).

### Showing logs

Execute:
```
docker logs fuseki -f
```

Ommit the `-f` if you don't want to follow the log. Use CTRL-C to stop following.

### Stopping, (re)starting and removing the container

```
docker stop fuseki
docker start fuseki
docker container rm fuseki
```

## Virtuoso

Default security is enabled for virtuoso: dba/dba

### Building the container
From the root directory of this repository, execute:

```
cd docker/virtuoso
docker build -t bp4mc2-virtuoso .
```

### Running the container
Execute:

```
docker run --detach --publish=8890:8890 --name=virtuoso bp4mc2-virtuoso
```

The Linked Data Theatre server will now be available at http://localhost:8890

If you want the webserver to be available on another port, change the first `8890` setting in the execution command above. You'll have to remove the container first (see below).

### Showing logs

Execute:
```
docker logs virtuoso -f
```

Ommit the `-f` if you don't want to follow the log. Use CTRL-C to stop following.

### Stopping, (re)starting and removing the container

```
docker stop virtuoso
docker start virtuoso
docker container rm virtuoso
```
