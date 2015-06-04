# Samhain Docker image

## Description

That image embed [samhain](http://www.la-samhna.de/samhain/), a tools for auditing Linux systems

The idea is to use Docker's lightweight isolation to have an auto-sufficient image that embed samhain and its dependencies, to perform on-demand audit without installing anything on your system, and leaving the place clean after the audit.

[![CircleCi Build Status](https://circleci.com/gh/dduportal-dockerfiles/samhain/tree/master.svg?&style=shield)](https://circleci.com/gh/dduportal-dockerfiles/samhain/tree/master)

## Usage

From here, just pre-download the image from the registry :

```
$ docker pull dduportal/samhain:3.1.5
```

It is strongly recommended to use tags, even if dduportal/samhain will work as latest tag is implied.

Then you have to choices : running directly your test or build your own, which enable you to embed your stuff.

### Basics run

* You can run the container in "quickie mode" to just run samhain in an isolated container :

``` bash
TODO
``` 

* To fetch logs, reports, use docker inside the container, or other advanced use cases, don't forget to share the need files and folders :

```bash
# Auditing a dockerfile which is in the current directory :
$ docker run \
	-v TODO
```

### Build your own testing image

The goal here is to embed your own stuff to adapt the behaviour of the image to your needs :
* Include your plugins
* Include your test profiles
* Pre-configure the image to make it indepednant from your host
...

For that, sue a Dockerfile :

```
$ cat Dockerfile
FROM dduportal/samhain:3.1.5
MAINTAINER <your name>
ADD ./your-plugins /app/plugins
ADD ./your-scripts /app/scripts
RUN yum install -q -y <package you need>
ENTRYPOINT ["/bin/sh"]
CMD ["/app/scripts/exec-samhain.sh"]
$ docker build -t my-samhain:1.0.0 ./
...
$ docker run -t my-samhain:1.0.0
...
```

## Image content and considerations

### Base image

Since this image just need bats and little dependencies, we use [Centos Linux 7](https://registry.hub.docker.com/_/centos/) as a base image.

### Already installed package

We embed a set of basic packages :
* bash : It is for convenience around the numerous samhain scripts that will need its
* curl (and ca-certificates): because we need to download stuff thru HTTPS for samhain checks
* openssl : cryptographic stuff Bro' 

## Contributing

Do not hesitate to contribute by forking this repository

Pick at least one :

* Implement tests in ```/tests/bats/```

* Write the Dockerfile

* (Re)Write the documentation corrections


Finnaly, open the Pull Request : CircleCi will automatically build and test for you
