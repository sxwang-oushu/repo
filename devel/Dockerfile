FROM ubuntu:18.04

LABEL maintainer="Sixue Wang"

ENV DEBIAN_FRONTEND=noninteractive

RUN apt-get update && apt-get install -y --no-install-recommends \
    tzdata \
    bsdmainutils \
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
  && apt-get clean \
  && rm -rf /var/lib/apt/lists/*

ENV DEBIAN_FRONTEND=

ARG CMAKE_URL=http://yum.oushu-tech.com/oushurepo/yumrepo/internal/linux/toolchain/cmake-3.12.4-Linux-x86_64.tar.gz
RUN mkdir /opt/cmake && curl -s $CMAKE_URL | tar xz --strip-components=1 -C /opt/cmake
ARG CLANG_URL=http://yum.oushu-tech.com/oushurepo/yumrepo/internal/linux/toolchain/clang+llvm-8.0.1-x86_64-linux-sles11.3.tar.xz
RUN mkdir /opt/clang && curl -s $CLANG_URL | tar xJ --strip-components=1 -C /opt/clang
ARG HADOOP_URL=https://ftp.riken.jp/net/apache/hadoop/common/hadoop-3.3.0/hadoop-3.3.0.tar.gz
RUN mkdir /opt/hadoop && curl -s $HADOOP_URL | tar xz --strip-components=1 -C /opt/hadoop
ARG DEP_URL=http://yumazure.oushu-tech.com:12000/oushurepo/yumrepo/internal/linux/toolchain/dependency-clang-x86_64-Linux.tar.gz
RUN curl -s $DEP_URL | tar xz -C /opt

# Setup Hadoop
ARG PORT=2144
RUN ssh-keygen -t rsa -P '' -f ~/.ssh/id_rsa && cat ~/.ssh/id_rsa.pub > ~/.ssh/authorized_keys && \
    echo "    Port $PORT" >> /etc/ssh/ssh_config && \
    echo "    Port $PORT" >> /etc/ssh/sshd_config

COPY hadoop/* /opt/hadoop/etc/hadoop/

ENV HADOOP_HOME=/opt/hadoop
ENV HDFS_NAMENODE_USER="root"
ENV HDFS_DATANODE_USER="root"
ENV HDFS_SECONDARYNAMENODE_USER="root"
ENV PATH=$HADOOP_HOME/bin:$HADOOP_HOME/sbin:$PATH

RUN hdfs namenode -format

# Setup scripts
WORKDIR /root

COPY profile /root/.profile
COPY bashrc /root/.bashrc

COPY build.sh /root/build.sh

COPY entrypoint.sh /root/entrypoint.sh
ENTRYPOINT /root/entrypoint.sh
