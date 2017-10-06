Nomad Docker Image for MobyVM
=============================

Run Hashicorp's Nomad in a Docker container in MobyVM for Hyper-V ([Docker for Windows](https://store.docker.com/editions/community/docker-ce-desktop-windows))
Makes it possible for developers to manage Linux containers locally from a Windows machine. Nomad currently does not support this ([Github](https://github.com/hashicorp/nomad/issues/2633))

Requirements
------------

 - Windows 10 or 2016 with Docker for Windows installed (MobyVM + Hyper-V)

Docker File
-----------

The Docker File is based on: 

https://github.com/eBayClassifiedsGroup/KomPaaS

https://github.com/djenriquez/nomad


and compiles a special fork of the Nomad binary:

https://github.com/frundh/nomad/tree/ip-from-env-var

Docker Hub
----------

https://hub.docker.com/r/frundh/nomad/

Docker Compose
--------------

The compose file creates three containers for Consul, Nomad and Hashi-ui

    docker-compose up -d

**Nomad** - http://localhost:4646

**Consul** - http://localhost:8500

**Hashi-UI** - http://localhost:3000

An example nomad job is included, run from an elevated shell with Nomad.exe in the PATH

    nomad run hello-world.nomad

Open to see available endpoints in Consul http://localhost:8500/v1/catalog/service/hello-world

**Optionally** start a Traefik reverse proxy with command

    nomad run traefik.nomad

**Traefik-UI** - http://localhost:8081

**Traefik-Proxy** - http://localhost:8080

Use Traefik proxy to access Hello-World app from http://localhost:8080/hello-world