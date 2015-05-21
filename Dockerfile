FROM gapsystem/gap-container

MAINTAINER The GAP Group <support@gap-system.org>

RUN sudo apt-get update -qq \
    && sudo apt-get -qq install -y libmpfr-dev libmpfi-dev libmpc-dev libfplll-dev\
    && cd /home/gap/inst/gap4r7/pkg \
    && sudo rm -rf \
    && sudo su - gap \
    && sudo wget -q http://www.gap-system.org/pub/gap/gap4pkgs/packages-v4.7.7.tar.gz \
    && sudo tar xzf packages-v4.7.7.tar.gz \
    && sudo rm packages-v4.7.7.tar.gz \
    && sudo wget https://raw.githubusercontent.com/gap-system/gap-docker/master/InstPackages.sh \
    && sudo chmod u+x InstPackages.sh \
    && sudo ./InstPackages.sh

# Start at $HOME.
WORKDIR /home/gap

# Start from a BASH shell.
CMD ["bash"]
