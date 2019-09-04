# Docker container for external software used by GAP packages.

This repository contains the dockerfile for the gap-docker-base image.
It is build on gap-system/gap-container and contains additional software,
used by some packages in GAP. External software at the moment is

* CXSC 2-5-4
* fplll 5.2.1
* Singular 4.1.2p1
* 4ti2 1.6.7
* PARI/GP 2.9.5
* Many Ubuntu packages providing dependencies for various GAP package, including
  libmpc, libmpfi, libmpfr, polymake, ...

# Build instructions

This build requires more resources, and therefore should be performed manually. In the `gap-docker-base` directory, call:
* `docker build --no-cache --tag="gapsystem/gap-docker-base:latest" .`
* `docker login`
* `docker push gapsystem/gap-docker-base:latest`
