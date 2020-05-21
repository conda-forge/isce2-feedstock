#!/bin/sh
set -xeuo pipefail

mkdir $SRC_DIR/build

# bake in autoRIFT
cp -r $SRC_DIR/autorift/geo_autoRIFT $SRC_DIR/isce2/contrib/

MODPATH=$(realpath $SP_DIR --relative-to=$PREFIX)

# build isce
cd $SRC_DIR/build
cmake $SRC_DIR/isce2 \
    -DCMAKE_BUILD_TYPE=Release \
    -DCMAKE_INSTALL_PREFIX=$PREFIX \
    -DPYTHON_MODULE_DIR=$MODPATH

# copy in autoRIFT executables
cp $SRC_DIR/autorift/test*.py $SRC_DIR/install/isce/applications/

# Move stack processors to share
mkdir -p $PREFIX/share/isce2
mv $SRC_DIR/isce2/contrib/stack/* $PREFIX/share/isce2
mv $SRC_DIR/isce2/contrib/timeseries/* $PREFIX/share/isce2

# Activate/deactivate scripts
mkdir -p $PREFIX/etc/conda/{de,}activate.d
cp $RECIPE_DIR/scripts/activate.sh $ACTIVATE_DIR/isce2-activate.sh
cp $RECIPE_DIR/scripts/deactivate.sh $DEACTIVATE_DIR/isce2-deactivate.sh
