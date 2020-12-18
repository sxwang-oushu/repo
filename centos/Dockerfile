# Licensed to the Apache Software Foundation (ASF) under one
# or more contributor license agreements.  See the NOTICE file
# distributed with this work for additional information
# regarding copyright ownership.  The ASF licenses this file
# to you under the Apache License, Version 2.0 (the
# "License"); you may not use this file except in compliance
# with the License.  You may obtain a copy of the License at
#
#   http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing,
# software distributed under the License is distributed on an
# "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY
# KIND, either express or implied.  See the License for the
# specific language governing permissions and limitations
# under the License.

FROM centos:7

MAINTAINER Richard Guo <riguo@pivotal.io>

# install all software we need
RUN yum install -y epel-release && \
 yum makecache && \
 yum install -y man passwd sudo tar which git mlocate links make bzip2 net-tools \
 autoconf automake libtool m4 gcc gcc-c++ gdb bison flex cmake gperf maven indent \
 libuuid-devel krb5-devel libgsasl-devel expat-devel libxml2-devel \
 perl-ExtUtils-Embed pam-devel python-devel libcurl-devel snappy-devel \
 thrift-devel libyaml-devel libevent-devel bzip2-devel openssl-devel \
 openldap-devel protobuf-devel readline-devel net-snmp-devel apr-devel \
 libesmtp-devel python-pip json-c-devel \
 java-1.8.0-openjdk-devel lcov cmake \
 openssh-clients openssh-server perl-JSON && \
 yum clean all

RUN pip --retries=50 --timeout=300 install pycrypto

ARG HADOOP_URL=https://ftp.riken.jp/net/apache/hadoop/common/hadoop-3.3.0/hadoop-3.3.0.tar.gz
RUN mkdir /opt/hadoop && curl -s $HADOOP_URL | tar xz --strip-components=1 -C /opt/hadoop

# hadoop
ARG PORT=2244
RUN ssh-keygen -A
RUN echo "y" | ssh-keygen -q -t rsa -P '' -f ~/.ssh/id_rsa && \
    cat ~/.ssh/id_rsa.pub > ~/.ssh/authorized_keys && \
    chmod 0600 ~/.ssh/authorized_keys && \
    echo "Port $PORT" >> /etc/ssh/ssh_config && \
    echo "Port $PORT" >> /etc/ssh/sshd_config
RUN sed -ri 's/^#PermitRootLogin yes/PermitRootLogin yes/' /etc/ssh/sshd_config
RUN sed -ri 's/^UsePAM yes/UsePAM no/' /etc/ssh/sshd_config

ADD hadoop/* /opt/hadoop/etc/hadoop/

ENV HADOOP_HOME=/opt/hadoop
ENV HADOOP_CONF_DIR=/opt/hadoop/etc/hadoop/
ENV PATH=$HADOOP_HOME/bin:$HADOOP_HOME/sbin:$PATH

# OS requirement
RUN echo "kernel.sem = 250 512000 100 2048" >> /etc/sysctl.conf

# create user gpadmin since HAWQ cannot run under root
RUN adduser -p gpadmin gpadmin && \
    usermod -aG gpadmin gpadmin && \
    install -o gpadmin -d /home/gpadmin && \
    install -o gpadmin -d /usr/local/hawq && \
    echo "gpadmin  ALL=(ALL)       NOPASSWD: ALL" > /etc/sudoers.d/gpadmin

# sudo should not require tty
RUN sed -i -e 's|Defaults    requiretty|#Defaults    requiretty|' /etc/sudoers

# setup JAVA_HOME for all users
RUN echo "#!/bin/sh" > /etc/profile.d/java.sh && \
 echo "export JAVA_HOME=/etc/alternatives/java_sdk" >> /etc/profile.d/java.sh && \
 chmod a+x /etc/profile.d/java.sh

# set USER env
RUN echo "#!/bin/bash" > /etc/profile.d/user.sh && \
 echo "export USER=\`whoami\`" >> /etc/profile.d/user.sh && \
 chmod a+x /etc/profile.d/user.sh

USER gpadmin

RUN echo "y" | ssh-keygen -q -t rsa -P '' -f ~/.ssh/id_rsa && \
    cat ~/.ssh/id_rsa.pub > ~/.ssh/authorized_keys && \
    chmod 0600 ~/.ssh/authorized_keys

RUN hdfs namenode -format

ADD --chown=gpadmin:gpadmin entrypoint.sh /home/gpadmin/entrypoint.sh

WORKDIR /home/gpadmin

ENTRYPOINT /home/gpadmin/entrypoint.sh
