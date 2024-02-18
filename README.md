docker-terraform
================

Dockerfile for Terraform

[![CI to Docker Hub](https://github.com/dceoy/docker-terraform/actions/workflows/docker-compose-build-and-push.yml/badge.svg)](https://github.com/dceoy/docker-terraform/actions/workflows/docker-compose-build-and-push.yml)

Docker image
------------

Pull the image from [Docker Hub](https://hub.docker.com/r/dceoy/terraform/).

```sh
$ docker image pull dceoy/terraform
```

Usage
-----

Test terraform commands.

```sh
$ docker container run --rm dceoy/terraform --version
```
