#!/bin/bash
set -ex

WITH_HORNET_EXECUTOR_ONLY=yes

if [ $# -ne 1 ];then
    echo "error: need one param"
    return 1
fi

WORKSPACE=/home/oushu/oushu/hornet/coverage
mkdir -p $WORKSPACE
cd $WORKSPACE

if [[ $1 = "init" ]];then
    ../bootstrap
    make coverage -j8
elif [[ $1 = "make" ]];then
    make coverage -j8
fi
lcov --base-directory . --directory . --capture --output-file CodeCoverage.info --ignore-errors graph;
lcov --remove CodeCoverage.info '/opt/*' '/usr/*' '/Library/*' '/Applications/*' '*/test/unit/*' '*/testutil/*' '*/protos/*' '*/proto/*' --output-file CodeCoverage.info.cleaned;
genhtml CodeCoverage.info.cleaned -o CodeCoverageReport;
