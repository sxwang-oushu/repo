set -ex

export RUN_UNITTEST=no
export LIBHDFS3_CONF=

(
cd libhdfs3
make -j8
)
(
cd hornet-opensource
make -j8
)
(
cd hornet
make -j8
)
(
cd hawq
./configure
make install -j8
)
