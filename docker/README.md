# Docker installation

## Prerequisite
Install [docker-for-windows](https://download.docker.com/win/stable/Docker%20for%20Windows%20Installer.exe) or [docker-for-mac](https://download.docker.com/mac/stable/Docker.dmg). More information can be found at [Installing Docker Desktop for Windows](https://docs.docker.com/docker-for-windows/install) or [Installing Docker Desktop for Mac](https://docs.docker.com/docker-for-mac/install).

Download and unzip the sources from this repository: https://github.com/bp4mc2/catalog/archive/master.zip

**OR** use git and make a clone: `git@github.com:bp4mc2/catalog.git`

## Networking
The networking configuration uses the simple host.docker.internal DNS entry which is only available in Docker Desktop. This means that the current configuration will not work in a production environment. Changes should be made to:

- /ldt/WEB-INF/resources/apps/ldt/config.xml (change `host.docker.internal` to `virtuoso`)
- /dotwebstack/resources/config/model/backend.trig (change `host.docker.internal` to `fuseki`)
- /nginx/default.conf (chang `host.docker.internal:*` to `virtuoso:8890`, `fuseki:3030`, `ldt:8080` and `dotwebstack:8081`)

## Kubernetes

If you want to use Kubernetes, you only haven to build the images. Do **not** run the containers with the commands below. For Kubernetes, use:

```
cd docker
docker stack deploy --compose-file docker-compose.yml bp4mc2-stack
```

Use `kubectl get po` to find out the status of the pods. Status *ImagePullBackOff* means that you probably haven't build the specific image.

The stack can be removed with `docker stack rm bp4mc2-stack`

The Kubernetes stack runs at port 80 by default. You can change this by editing the webserver entry in the [docker-compose.yml](docker-compose.yml) file.

The following services can be reached from http:localhost:
- http://localhost The Linked Data Theatre
- http://localhost/dws The Dot WebStack server
- http://localhost/fuseki The fuseki server
- http://localhost/conductor The Virtuoso conductor

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

## LDT config

### Building the container
From the root directory of this repository, execute:

```
cd docker/ldt-config
docker build -t bp4mc2-ldt-config .
```

### Running the container
This container is a bit special: it is supposed to work as a shell to run commands against

The actual container in the docker compose is doing absolutely nothing (e.g. /bin/sleep).

To execute the actual command, you first need to find out the pod, using `kubectl get po`, and than run the following command:

```
kubectl exec <POD> ./run.sh
```

This will execute the run script within the container, just ones.

TODO:
- The virtuoso database doesn't run correctly. Maybe we need to create an update script (at port 1111)?
- Maybe we can include the actual config as part of the virtuoso container
- At least the run.sh command should be run as part of the start-up of this container
- Maybe we can find some way to "dispose" of this container, or do it some other way...
