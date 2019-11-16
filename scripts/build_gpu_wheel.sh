#!/bin/bash


set -x

mkdir build
cd build

case ${TRAVIS_OS_NAME} in
linux)
    cmake ..
    ;;
osx)
   ;;
windows)
    export PATH=${MSBUILD_PATH}:$PATH
    cmake -DCMAKE_WINDOWS_EXPORT_ALL_SYMBOLS=TRUE -DBUILD_SHARED_LIBS=TRUE -G "Visual Studio 14 2015 Win64" ..
    choco install python --version=3.6.3
    python -m pip install --upgrade pip
    pip install wheel
    ;;
esac

cmake --build .
cd ../python
python setup.py bdist_wheel
