FROM gapsystem/gap-container

MAINTAINER The GAP Group <support@gap-system.org>


# Prerequirements
RUN    sudo apt-get update -qq \
    && sudo apt-get -qq install -y \
                                   ## Polymake stuff
                                   ant ant-optional g++ libboost-dev \
                                   libgmp-dev libgmpxx4ldbl libmpfr-dev libperl-dev \
                                   libsvn-perl libterm-readline-gnu-perl \
                                   libxml-libxml-perl libxml-libxslt-perl libxml-perl \
                                   libxml-writer-perl libxml2-dev w3c-dtd-xhtml xsltproc \
                                   bliss libbliss-dev \
                                   ## GAP stuff
                                   libmpfr-dev libmpfi-dev libmpc-dev libfplll-dev \
                                   ## Singular stuff
                                   autoconf autogen libtool libreadline6-dev libglpk-dev \
                                   libmpfr-dev libcdd-dev libntl-dev git

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
    && sudo mkdir Singular \
    && sudo chown -hR gap Singular \
    && cd Singular \
    && git clone https://github.com/Singular/Sources.git \
    && cd Sources \
    && ./autogen.sh \
    && ./configure --enable-gfanlib --with-flint=yes \
    && make -j \
    && sudo make install

# Polymake
RUN    cd /tmp \
    && wget http://www.polymake.org/lib/exe/fetch.php/download/polymake-2.14.tar.bz2 \
    && tar -xf polymake-2.14.tar.bz2 \
    && cd polymake-2.14 \\
    && ./configure --without-java --with-gmp=system \
    && make -j \
    && sudo make install \
    && cd /tmp \
    && rm -rf polymake*

# 4ti2
RUN    cd /opt \
    && sudo wget http://www.4ti2.de/version_1.6.3/4ti2-1.6.3.tar.gz \
    && sudo tar -xf 4ti2-1.6.3.tar.gz \
    && sudo chown -hR gap 4ti2-1.6.3 \
    && sudo rm 4ti2-1.6.3.tar.gz \
    && cd 4ti2-1.6.3 \
    && ./configure \
    && make -j \
    && sudo make install

# Pari/GP
RUN    cd /tmp/ \
    && wget http://pari.math.u-bordeaux.fr/pub/pari/unix/OLD/2.7/pari-2.7.3.tar.gz \
    && tar -xf pari-2.7.3.tar.gz \
    && cd pari-2.7.3 \
    && ./Configure \
    && sudo make install

# Start at $HOME.
WORKDIR /home/gap

# Start from a BASH shell.
CMD ["bash"]
