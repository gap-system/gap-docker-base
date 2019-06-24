FROM gapsystem/gap-container

MAINTAINER The GAP Group <support@gap-system.org>

ENV DEBIAN_FRONTEND noninteractive

# Prerequirements
RUN    sudo apt-get update -qq \
    && sudo ln -fs /usr/share/zoneinfo/America/New_York /etc/localtime \
    && sudo apt-get -qq install -y \
                                libboost-dev \
                                libgmp-dev libgmpxx4ldbl \
                                libmpfr-dev libmpfi-dev libmpc-dev \
                                autoconf autogen libtool libreadline6-dev libglpk-dev \
                                libmpfr-dev libcdd-dev libntl-dev git polymake

ENV CXSC_VERSION 2-5-4
ENV FPLLL_VERSION 5.2.1
ENV SINGULAR_VERSION 4.1.1
ENV SINGULAR_PATCH p2
ENV _4TI2_VERSION 1_6_7
ENV PARI_VERSION 2.9.5

# CXSC (for Float)
RUN    cd /tmp \
    && wget http://www2.math.uni-wuppertal.de/wrswt/xsc/cxsc/cxsc-${CXSC_VERSION}.tar.gz \
    && tar -xf cxsc-${CXSC_VERSION}.tar.gz \
    && mkdir cxscbuild \
    && cd cxscbuild \
    && cmake -DCMAKE_INSTALL_PREFIX:PATH=/tmp/cxsc /tmp/cxsc-${CXSC_VERSION} \
    && make \
    && sudo make install

# libfplll (for Float)
RUN    cd /tmp \
    && wget https://github.com/fplll/fplll/releases/download/${FPLLL_VERSION}/fplll-${FPLLL_VERSION}.tar.gz \
    && tar -xf fplll-${FPLLL_VERSION}.tar.gz \
    && rm fplll-${FPLLL_VERSION}.tar.gz \
    && cd fplll-${FPLLL_VERSION} \
    && ./configure \
    && make \
    && sudo make install \
    && cd /tmp \
    && rm -rf fplll-${FPLLL_VERSION}


# flint (for Singular)
RUN    cd /tmp \
    && git clone https://github.com/wbhart/flint2.git \
    && cd flint2 \
    && ./configure \
    && make -j \
    && sudo make install \
    && cd /tmp \
    && rm -rf flint2

# Singular
RUN    cd /opt \
    && sudo wget http://www.mathematik.uni-kl.de/ftp/pub/Math/Singular/SOURCES/$(echo ${SINGULAR_VERSION} | tr . -)/singular-${SINGULAR_VERSION}${SINGULAR_PATCH}.tar.gz \
    && sudo tar -xf singular-${SINGULAR_VERSION}${SINGULAR_PATCH}.tar.gz \
    && sudo rm singular-${SINGULAR_VERSION}${SINGULAR_PATCH}.tar.gz \
    && sudo chown -hR gap singular-${SINGULAR_VERSION} \
    && cd singular-${SINGULAR_VERSION} \
    && ./configure \
    && make -j \
    && sudo make install

# 4ti2
RUN    cd /opt \
    && sudo wget https://github.com/4ti2/4ti2/archive/Release_${_4TI2_VERSION}.tar.gz \
    && sudo tar -xf Release_${_4TI2_VERSION}.tar.gz \
    && sudo chown -hR gap 4ti2-Release_${_4TI2_VERSION} \
    && sudo rm Release_${_4TI2_VERSION}.tar.gz \
    && cd 4ti2-Release_${_4TI2_VERSION} \
    && chmod +x autogen.sh \
    && ./autogen.sh \
    && ./configure \
    && touch doc/4ti2_manual.pdf \
    && make -j \
    && sudo make install

# Pari/GP
RUN    cd /tmp/ \
    && wget https://pari.math.u-bordeaux.fr/pub/pari/unix/pari-${PARI_VERSION}.tar.gz \
    && tar -xf pari-${PARI_VERSION}.tar.gz \
    && rm pari-${PARI_VERSION}.tar.gz \
    && cd pari-${PARI_VERSION} \
    && ./Configure \
    && sudo make install

ENV LD_LIBRARY_PATH /usr/local/lib:${LD_LIBRARY_PATH}

# Start at $HOME.
WORKDIR /home/gap

# Start from a BASH shell.
CMD ["bash"]
