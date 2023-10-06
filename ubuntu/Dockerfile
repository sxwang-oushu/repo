FROM ubuntu:22.04

LABEL maintainer="Sixue Wang"

RUN sed -i 's/\/\/archive.ubuntu.com/\/\/jp.archive.ubuntu.com/g' /etc/apt/sources.list && \
    sed -i 's/\/\/us.archive.ubuntu.com/\/\/jp.archive.ubuntu.com/g' /etc/apt/sources.list && \
    sed -i 's/\/\/fr.archive.ubuntu.com/\/\/jp.archive.ubuntu.com/g' /etc/apt/sources.list && \
    apt update && \
    DEBIAN_FRONTEND=noninteractive apt install -y --no-install-recommends \
      apport \
      systemd \
      sudo \
      #tzdata \
      #bsdmainutils \
      gawk \
      curl \
      git \
      lcov \
      less \
      openssh-server \
      software-properties-common \
      wget \
      tree \
      vim \
      pkg-config \
      cmake \
      #xz-utils \
      #uuid-dev \
      #libncurses5-dev \
      #libreadline-dev \
      #openjdk-8-jdk \
      net-tools \
      iputils-ping \
      iproute2 \
      fuse \
      ccache \
      build-essential \
      g++-12 \
      gcc-12 && \
      # perf
      #linux-tools-$(uname -r) linux-tools-generic && \
    apt clean && \
    rm -rf /var/lib/apt/lists/*

RUN update-alternatives --install /usr/bin/gcc gcc /usr/bin/gcc-12 1230 && \
    update-alternatives --install /usr/bin/g++ g++ /usr/bin/g++-12 1230

# Enable coredump
#RUN systemctl enable apport.service && \
#    sysctl -w kernel.core_pattern=/tmp/core.%u.%t

# Enable lldb attach
# RUN echo 0 > /proc/sys/kernel/yama/ptrace_scope

# Setup User
RUN adduser --disabled-password --gecos "" oushu && \
    usermod -aG sudo oushu && \
    echo "root:root" | chpasswd && \
    echo "oushu:oushu" | chpasswd && \
    mkdir /usr/local/oushu && \
    install -o oushu -d /usr/local/oushu && \
    mkdir /usr/local/gpdb && \
    install -o oushu -d /usr/local/gpdb && \
    install -o oushu -d /opt
    #chmod a+w /etc/ssh/ssh_config && \
    #chmod a+w /etc/ssh/sshd_config && \

USER oushu
WORKDIR /home/oushu
ENV USER=oushu

# Setup ToolChain
ENV CC=gcc
ENV CXX=g++
ENV LD=ld

ENV CFLAGS='-gdwarf-4'
ENV CXXFLAGS='-gdwarf-4'
ENV LDFLAGS="-lstdc++"

# Install libhdfs3.git
#ADD --chown=oushu:oushu id_rsa /home/oushu/.ssh/id_rsa
#ADD --chown=oushu:oushu id_rsa.pub /home/oushu/.ssh/id_rsa.pub
#RUN ssh-keyscan github.com >> /home/oushu/.ssh/known_hosts
#RUN cd /tmp && \
#    git clone git@github.com:oushu-io/libhdfs3.git && \
#    cd libhdfs3 && \
#    bash -c "source /opt/dependency-clang-x86_64-Linux/package/env.sh && make -j8" && \
#    cd .. && rm -rf libhdfs3

# Setup Hadoop
#ARG HADOOP_URL=https://ftp.riken.jp/net/apache/hadoop/common/hadoop-3.3.0/hadoop-3.3.0.tar.gz
#RUN mkdir /opt/hadoop && curl -s $HADOOP_URL | tar xz --strip-components=1 -C /opt/hadoop
#ARG PORT=2144
#RUN echo "y" | ssh-keygen -q -t rsa -P '' -f ~/.ssh/id_rsa && \
#    cat ~/.ssh/id_rsa.pub > ~/.ssh/authorized_keys && \
#    echo "    Port $PORT" >> /etc/ssh/ssh_config && \
#    echo "    Port $PORT" >> /etc/ssh/sshd_config

#ADD hadoop/* /opt/hadoop/etc/hadoop/

#ENV HADOOP_HOME=/opt/hadoop
#ENV HADOOP_CONF_DIR=/opt/hadoop/etc/hadoop/
#ENV PATH=$HADOOP_HOME/bin:$HADOOP_HOME/sbin:$PATH

#RUN hdfs namenode -format

# Setup environment variable
#ENV DEPENDENCY_PATH=/opt/dependency/package
#ENV RUN_UNITTEST=no
#ENV TEST_DB_NAME="hawq_feature_test_db"
#ENV PGDATABASE=$TEST_DB_NAME
#ENV PGUSER=$USER

ADD --chown=oushu:oushu dependency /opt/dependency
ADD --chown=oushu:oushu profile /home/oushu/.profile
ADD --chown=oushu:oushu bashrc /home/oushu/.bashrc

ENV DISPLAY=:0
#ENV PATH=/home/oushu/oushu/repo/ubuntu/sbin:$PATH

#RUN mkdir /tmp/magma_segment

#ENTRYPOINT /home/oushu/oushu/repo/ubuntu/sbin/entrypoint.sh