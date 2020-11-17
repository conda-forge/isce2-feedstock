#!/bin/sh

set -x
SHORT_OS_STR=$(uname -s)

# XXX Kludge for broken Xfuncproto.h provided by macOS tk conda-forge package
if [[ "$OSTYPE" == "darwin"* ]]; then
    # Force reinstall these to (un)clobber any broken headers
    conda install -p ${PREFIX} -c conda-forge \
        xorg-xproto \
        xorg-libxt \
        xorg-libx11 \
        --yes --clobber --force-reinstall
fi

mkdir $SRC_DIR/{build,install,config,bin}

##Setup a link to cython here
ln -s $PREFIX/bin/cython $SRC_DIR/bin/cython3

#Setting up some environment variables
export PATH="${PATH}:${SRC_DIR}/bin"
export LD_LIBRARY_PATH=$LD_LIBRARYPATH:$PREFIX/lib

#Set up SConfigISCE file
echo "PYTHON USED = $PYTHON"
export PYTHON_INCDIR=`$PYTHON -c "from sysconfig import get_paths; print(get_paths()['include'])"`
export NUMPY_INCDIR=`$PYTHON -c "import numpy; print(numpy.get_include())"`

echo "
PRJ_SCONS_BUILD = $SRC_DIR/build
PRJ_SCONS_INSTALL = $SRC_DIR/install/isce
LIBPATH = $PREFIX/lib
CPPPATH = $PREFIX/include $PREFIX/include/opencv4 $PYTHON_INCDIR $NUMPY_INCDIR
FORTRANPATH = $PREFIX/include
CC = $CC
CXX = $CXX
# XXX remove -fcommon after https://github.com/isce-framework/isce2/pull/158 is merged
CCFLAGS = -fcommon
FORTRAN = $FC
" >> $SRC_DIR/config/SConfigISCE

if [ "${SHORT_OS_STR}" == "Darwin" ]; then
    echo "STDCPPLIB = c++" >> $SRC_DIR/config/SConfigISCE
fi
echo "MOTIFLIBPATH = ${PREFIX}/lib
MOTIFINCPATH = ${PREFIX}/include
X11LIBPATH = ${PREFIX}/lib
X11INCPATH = ${PREFIX}/include
" >> $SRC_DIR/config/SConfigISCE

echo "*****SConfigISCE*****"
cat $SRC_DIR/config/SConfigISCE
echo "*****EndOfFile*******"

# build isce
export SCONS_CONFIG_DIR=$SRC_DIR/config
cd $SRC_DIR/isce2
scons install --skipcheck

# mark completion and ensure directory is not empty
mkdir -p $SRC_DIR/install/isce/helper
touch $SRC_DIR/install/isce/helper/completed

##Restore environment
unset SCONS_CONFIG_DIR

##Move installation to site-packages
mv $SRC_DIR/install/isce $SP_DIR
rm -rf $SRC_DIR/build

#Move stack processors to share
mkdir -p $PREFIX/share/isce2
mv $SRC_DIR/isce2/contrib/stack/* $PREFIX/share/isce2
mv $SRC_DIR/isce2/contrib/timeseries/* $PREFIX/share/isce2

###Activate/ deactivate scripts
ACTIVATE_DIR=$PREFIX/etc/conda/activate.d
DEACTIVATE_DIR=$PREFIX/etc/conda/deactivate.d
mkdir -p $ACTIVATE_DIR
mkdir -p $DEACTIVATE_DIR

cp $RECIPE_DIR/scripts/activate.sh $ACTIVATE_DIR/isce2-activate.sh
cp $RECIPE_DIR/scripts/deactivate.sh $DEACTIVATE_DIR/isce2-deactivate.sh

