#!/bin/bash

set -x

cd ${0%%$(basename $0)}
mkdir build
cd build

if [ -z "$PYTHON_VERSION" ] ; then
    PYTHON_VERSION=`python -c "import sys;t='{v[0]}.{v[1]}'.format(v=list(sys.version_info[:2]));sys.stdout.write(t)";`
fi

if [[ "$OSTYPE" == "linux-gnu" || "$OSTYPE" == "linux" ]]; then
    [ -f /etc/lsb-release ] && source /etc/lsb-release
    if [ "$DISTRIB_RELEASE" = "18.04" -a "$PYTHON_VERSION" = "3.6" ] ; then
        VERSION_SUFFIX="-py36"
    fi
    cmake -DPYTHON_VERSION_SUFFIX=$VERSION_SUFFIX -DCMAKE_BUILD_TYPE=DEBUG .. && make && make test
elif [[ "$OSTYPE" == "darwin"* ]]; then
    PYTHON_LIBRARY=/usr/local/Frameworks/Python.framework/Versions/$PYTHON_VERSION/lib/libpython$PYTHON_VERSION.dylib
    PYTHON_INCLUDE_DIR=/usr/local/Frameworks/Python.framework/Versions/$PYTHON_VERSION/Headers/
    cmake -DPYTHON_LIBRARY=$PYTHON_LIBRARY -DPYTHON_INCLUDE_DIR=$PYTHON_INCLUDE_DIR -DCMAKE_BUILD_TYPE=DEBUG .. && make && make test
elif [[ "$OSTYPE" == "cygwin" ]]; then
    : # POSIX compatibility layer and Linux environment emulation for Windows
elif [[ "$OSTYPE" == "msys" ]]; then
    : # shell and GNU utilities compiled for Windows as part of MinGW
elif [[ "$OSTYPE" == "win32" ]]; then
    : # good luck
elif [[ "$OSTYPE" == "freebsd"* ]]; then
    : # ...
else
    : # Unknown.
fi



