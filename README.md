# Docker container for external software used by GAP packages.

This repository contains the dockerfile for the gap-docker-base image.
It is build on gap-system/gap-container and contains additional software,
used by some packages in GAP. External software at the moment is

* Ubuntu packages libmpfr-dev libmpfi-dev libmpc-dev libfplll-dev (needed by the float package)
* Polymake 2.14 (and dependencies, listed on polymake.org)
* Singular (git version of the day)
* 4ti2 1.6.3
* PARI/GP 2.7.3


