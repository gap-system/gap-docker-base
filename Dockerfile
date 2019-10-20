FROM ubuntu:bionic

MAINTAINER The GAP Group <support@gap-system.org>

ENV DEBIAN_FRONTEND noninteractive

# Prerequisites
RUN    dpkg --add-architecture i386 \
    && apt-get update -qq \
    && apt-get -qq install -y \
            autoconf \
            autogen \
            automake \
            build-essential \
            cmake \
            curl \
            g++ \
            gcc \
            gcc-multilib \
            git \
            libboost-dev \
            libcdd-dev \
            libcurl4-openssl-dev \
            libflint-dev \
            libgmp-dev \
            libgmpxx4ldbl \
            libmpc-dev \
            libmpfi-dev \
            libmpfr-dev \
            libncurses5-dev \
            libntl-dev \
            libreadline6-dev \
            libtool \
            libxml2-dev \
            libzmq3-dev \
            m4 \
            mercurial \
            polymake \
            python3-pip \
            sudo \
            unzip \
            wget \
    && ln -fs /usr/share/zoneinfo/America/New_York /etc/localtime

RUN pip3 install notebook jupyterlab_launcher jupyterlab traitlets ipython vdom

# add gap user
RUN    adduser --quiet --shell /bin/bash --gecos "GAP user,101,," --disabled-password gap \
    && adduser gap sudo \
    && chown -R gap:gap /home/gap/ \
    && echo '%sudo ALL=(ALL) NOPASSWD:ALL' >> /etc/sudoers \
    && cd /home/gap \
    && touch .sudo_as_admin_successful

# CXSC (for Float)
ENV CXSC_VERSION 2-5-4
RUN    cd /tmp \
    && wget http://www2.math.uni-wuppertal.de/wrswt/xsc/cxsc/cxsc-${CXSC_VERSION}.tar.gz \
    && tar -xf cxsc-${CXSC_VERSION}.tar.gz \
    && mkdir cxscbuild \
    && cd cxscbuild \
    && cmake -DCMAKE_INSTALL_PREFIX:PATH=/tmp/cxsc /tmp/cxsc-${CXSC_VERSION} \
    && make \
    && make install

# libfplll (for Float)
ENV FPLLL_VERSION 5.2.1
RUN    cd /tmp \
    && wget https://github.com/fplll/fplll/releases/download/${FPLLL_VERSION}/fplll-${FPLLL_VERSION}.tar.gz \
    && tar -xf fplll-${FPLLL_VERSION}.tar.gz \
    && rm fplll-${FPLLL_VERSION}.tar.gz \
    && cd fplll-${FPLLL_VERSION} \
    && ./configure \
    && make \
    && make install \
    && cd /tmp \
    && rm -rf fplll-${FPLLL_VERSION}


# flint (for Singular)
# RUN    cd /tmp \
#     && git clone https://github.com/wbhart/flint2.git \
#     && cd flint2 \
#     && ./configure \
#     && make -j4 \
#     && make install \
#     && cd /tmp \
#     && rm -rf flint2

# Singular
ENV SINGULAR_VERSION 4.1.2
ENV SINGULAR_PATCH p1
RUN    cd /opt \
    && wget http://www.mathematik.uni-kl.de/ftp/pub/Math/Singular/SOURCES/$(echo ${SINGULAR_VERSION} | tr . -)/singular-${SINGULAR_VERSION}${SINGULAR_PATCH}.tar.gz \
    && tar -xf singular-${SINGULAR_VERSION}${SINGULAR_PATCH}.tar.gz \
    && rm singular-${SINGULAR_VERSION}${SINGULAR_PATCH}.tar.gz \
    && chown -hR gap singular-${SINGULAR_VERSION} \
    && cd singular-${SINGULAR_VERSION} \
    && ./configure \
    && make -j4 \
    && make install

# 4ti2
ENV _4TI2_VERSION 1_6_7
RUN    cd /opt \
    && wget https://github.com/4ti2/4ti2/archive/Release_${_4TI2_VERSION}.tar.gz \
    && tar -xf Release_${_4TI2_VERSION}.tar.gz \
    && chown -hR gap 4ti2-Release_${_4TI2_VERSION} \
    && rm Release_${_4TI2_VERSION}.tar.gz \
    && cd 4ti2-Release_${_4TI2_VERSION} \
    && chmod +x autogen.sh \
    && ./autogen.sh \
    && ./configure \
    && touch doc/4ti2_manual.pdf \
    && make -j4 \
    && make install

# Pari/GP
ENV PARI_VERSION 2.9.5
RUN    cd /tmp/ \
    && wget https://pari.math.u-bordeaux.fr/pub/pari/OLD/2.9/pari-${PARI_VERSION}.tar.gz \
    && tar -xf pari-${PARI_VERSION}.tar.gz \
    && rm pari-${PARI_VERSION}.tar.gz \
    && cd pari-${PARI_VERSION} \
    && ./Configure \
    && make install

# Macaulay2
RUN    echo "deb http://www.math.uiuc.edu/Macaulay2/Repositories/Ubuntu $(lsb_release -sc) main" >/etc/apt/sources.list.d/macaulay2.list \
    && wget http://www2.macaulay2.com/Macaulay2/PublicKeys/Macaulay2-key \
    && apt-key add Macaulay2-key \
    && apt-get update -qq \
    && apt-get -qq install -y macaulay2

ENV LD_LIBRARY_PATH /usr/local/lib:${LD_LIBRARY_PATH}

# Set up new user and home directory in environment.
USER gap
ENV HOME /home/gap

# Note that WORKDIR will not expand environment variables in docker versions < 1.3.1.
# See docker issue 2637: https://github.com/docker/docker/issues/2637
# Start at $HOME.
WORKDIR /home/gap

# Start from a BASH shell.
CMD ["bash"]
