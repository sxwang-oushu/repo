FROM ubuntu:18.04

LABEL maintainer="Sixue Wang"

RUN apt-get update && \
    DEBIAN_FRONTEND=noninteractive apt-get install -y --no-install-recommends \
      sudo \
      tzdata \
      bsdmainutils \
      gawk \
      curl \
      git \
      lcov \
      less \
      openssh-server \
      software-properties-common \
      wget \
      pkg-config \
      xz-utils \
      uuid-dev \
      libncurses5-dev \
      libreadline-dev \
      openjdk-8-jdk \
      net-tools \
      iputils-ping \
      iproute2 && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

ARG CMAKE_URL=http://yum.oushu-tech.com/oushurepo/yumrepo/internal/linux/toolchain/cmake-3.12.4-Linux-x86_64.tar.gz
RUN mkdir /opt/cmake && curl -s $CMAKE_URL | tar xz --strip-components=1 -C /opt/cmake
ARG CLANG_URL=http://yum.oushu-tech.com/oushurepo/yumrepo/internal/linux/toolchain/clang+llvm-8.0.1-x86_64-linux-sles11.3.tar.xz
RUN mkdir /opt/clang && curl -s $CLANG_URL | tar xJ --strip-components=1 -C /opt/clang
ARG HADOOP_URL=https://ftp.riken.jp/net/apache/hadoop/common/hadoop-3.3.0/hadoop-3.3.0.tar.gz
RUN mkdir /opt/hadoop && curl -s $HADOOP_URL | tar xz --strip-components=1 -C /opt/hadoop
ARG DEP_URL=http://yumazure.oushu-tech.com:12000/oushurepo/yumrepo/internal/linux/toolchain/dependency-clang-x86_64-Linux.tar.gz
RUN curl -s $DEP_URL | tar xz -C /opt

# Setup User
RUN adduser --disabled-password --gecos "" oushu && \
    usermod -aG sudo oushu && \
    echo "root:root" | chpasswd && \
    echo "oushu:oushu" | chpasswd && \
    chmod a+w /etc/ssh/ssh_config && \
    chmod a+w /etc/ssh/sshd_config && \
    chmod a+w /opt && \
    install -o oushu -d /usr/local/hawq

USER oushu
WORKDIR /home/oushu
ENV USER=oushu

# Setup ToolChain
ENV CC=clang
ENV CXX=clang++
ENV LD=ld.lld

ENV CPPFLAGS=
ENV CFLAGS=
ENV CXXFLAGS='-stdlib=libc++'
ENV LDFLAGS="-Wl,-rpath,/opt/dependency/package/lib -rtlib=compiler-rt -lgcc_s $LDFLAGS"

ENV CPATH=/opt/clang/include/c++/v1/
ENV LIBRARY_PATH=/opt/clang/lib

ENV PATH=/opt/clang/bin:/opt/cmake/bin:$PATH
ENV LD_LIBRARY_PATH=/opt/clang/lib:$LD_LIBRARY_PATH


# Install libhdfs3.git
ADD --chown=oushu:oushu id_rsa /home/oushu/.ssh/id_rsa
ADD --chown=oushu:oushu id_rsa.pub /home/oushu/.ssh/id_rsa.pub
RUN ssh-keyscan github.com >> /home/oushu/.ssh/known_hosts
RUN cd /tmp && \
    git clone git@github.com:oushu-io/libhdfs3.git && \
    cd libhdfs3 && \
    bash -c "source /opt/dependency-clang-x86_64-Linux/package/env.sh && make -j8" && \
    cd .. && rm -rf libhdfs3

# Setup Hadoop
ARG PORT=2144
RUN echo "y" | ssh-keygen -q -t rsa -P '' -f ~/.ssh/id_rsa && \
    cat ~/.ssh/id_rsa.pub > ~/.ssh/authorized_keys && \
    echo "    Port $PORT" >> /etc/ssh/ssh_config && \
    echo "    Port $PORT" >> /etc/ssh/sshd_config

ADD hadoop/* /opt/hadoop/etc/hadoop/

ENV HADOOP_HOME=/opt/hadoop
ENV PATH=$HADOOP_HOME/bin:$HADOOP_HOME/sbin:$PATH

RUN hdfs namenode -format

# Setup scripts
ADD --chown=oushu:oushu sbin /home/oushu/sbin/
ENV PATH=/home/oushu/sbin:$PATH

# Setup environment variable
ENV DEPENDENCY_PATH=/opt/dependency/package
ENV RUN_UNITTEST=no
ENV TEST_DB_NAME="hawq_feature_test_db"

ADD --chown=oushu:oushu profile /home/oushu/.profile
ADD --chown=oushu:oushu bashrc /home/oushu/.bashrc

ENTRYPOINT /home/oushu/sbin/entrypoint.sh
