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

# CXSC (for Float)
RUN    cd /tmp \
    && wget http://www2.math.uni-wuppertal.de/~xsc/xsc/cxsc/cxsc-2-5-4.tar.gz \
    && tar -xf cxsc-2-5-4.tar.gz \
    && mkdir cxscbuild \
    && cd cxscbuild \
    && cmake -DCMAKE_INSTALL_PREFIX:PATH=/tmp/cxsc /tmp/cxsc-2-5-4 \
    && make \
    && sudo make install

# libfplll (for Float)
RUN    cd /tmp \
    && wget https://github.com/fplll/fplll/releases/download/5.2.1/fplll-5.2.1.tar.gz \
    && tar -xf fplll-5.2.1.tar.gz \
    && rm fplll-5.2.1.tar.gz \
    && cd fplll-5.2.1 \
    && ./configure \
    && make \
    && sudo make install \
    && cd /tmp \
    && rm -rf fplll-5.2.1


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
    && sudo wget http://www.mathematik.uni-kl.de/ftp/pub/Math/Singular/SOURCES/4-1-1/singular-4.1.1p2.tar.gz \
    && sudo tar -xf singular-4.1.1p2.tar.gz \
    && sudo rm singular-4.1.1p2.tar.gz \
    && sudo chown -hR gap singular-4.1.1 \
    && cd singular-4.1.1 \
    && ./configure \
    && make -j \
    && sudo make install

# 4ti2
RUN    cd /opt \
    && sudo wget http://www.4ti2.de/version_1.6.7/4ti2-1.6.7.tar.gz \
    && sudo tar -xf 4ti2-1.6.7.tar.gz \
    && sudo chown -hR gap 4ti2-1.6.7 \
    && sudo rm 4ti2-1.6.7.tar.gz \
    && cd 4ti2-1.6.7 \
    && ./configure \
    && make -j \
    && sudo make install

# Pari/GP
RUN    cd /tmp/ \
    && wget https://pari.math.u-bordeaux.fr/pub/pari/unix/pari-2.9.5.tar.gz \
    && tar -xf pari-2.9.5.tar.gz \
    && rm pari-2.9.5.tar.gz \
    && cd pari-2.9.5 \
    && ./Configure \
    && sudo make install

ENV LD_LIBRARY_PATH /usr/local/lib:${LD_LIBRARY_PATH}

# Start at $HOME.
WORKDIR /home/gap

# Start from a BASH shell.
CMD ["bash"]
