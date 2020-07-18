#!/bin/sh
set -xeuo pipefail

MODPATH=$(python3 -c "import os.path; print(os.path.relpath('$SP_DIR', '$PREFIX'))")

# build isce
mkdir $SRC_DIR/build
cd $SRC_DIR/build
cmake $SRC_DIR/isce2 \
    -DCMAKE_BUILD_TYPE=Release \
    -DCMAKE_INSTALL_PREFIX=$PREFIX \
    -DPYTHON_MODULE_DIR=$MODPATH
make -j4 install

# Create help directory
# TODO: should the Python module, or even CMake scripts handle this?
mkdir -p $SP_DIR/isce2/helper

# Move stack processors to share
mkdir -p $PREFIX/share/isce2
mv $SRC_DIR/isce2/contrib/stack/* $PREFIX/share/isce2
mv $SRC_DIR/isce2/contrib/timeseries/* $PREFIX/share/isce2
