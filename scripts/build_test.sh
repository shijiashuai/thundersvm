#!/bin/bash

case ${TRAVIS_OS_NAME} in
linux)
    mkdir build-test
    cd build-test
    cmake -DBUILD_TESTS=ON -DUSE_CUDA=OFF -DUSE_EIGEN=ON ..
    ;;
osx)
   ;;
windows)
    mkdir build-test
    cd build-test
    cmake -DBUILD_TESTS=ON -DUSE_CUDA=OFF -DUSE_EIGEN=ON ..
    export PATH=${MSBUILD_PATH}:$PATH
    cmake -DCMAKE_WINDOWS_EXPORT_ALL_SYMBOLS=TRUE -DBUILD_SHARED_LIBS=TRUE -DUSE_CUDA=OFF -DUSE_EIGEN=ON -DBUILD_TESTS=ON -G "Visual Studio 14 2015 Win64" ..
    ;;
esac
