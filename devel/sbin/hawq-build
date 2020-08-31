#!/bin/bash
set -ex

#export RUN_UNITTEST=no
#export WITH_HORNET_EXECUTOR_ONLY=yes
export LIBHDFS3_CONF=

WORKSPACE=/home/oushu/oushu
cd $WORKSPACE

cd hornet-opensource
make -j8
cd ..

cd hornet
make -j8
cd ..

cd hawq
./configure
make install -j8
make feature-test -j8
cd ..
