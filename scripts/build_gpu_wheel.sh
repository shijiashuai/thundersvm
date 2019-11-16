#!/bin/bash

set -x

mkdir build
cd build

case ${TRAVIS_OS_NAME} in
linux)
    INSTALLER=cuda-repo-${UBUNTU_VERSION}_${CUDA}_amd64.deb
    wget http://developer.download.nvidia.com/compute/cuda/repos/${UBUNTU_VERSION}/x86_64/${INSTALLER}
    sudo dpkg -i ${INSTALLER}
    wget https://developer.download.nvidia.com/compute/cuda/repos/${UBUNTU_VERSION}/x86_64/7fa2af80.pub
    sudo apt-key add 7fa2af80.pub
    sudo apt update -qq
    sudo apt install -y cuda-core-${CUDA_SHORT/./-} cuda-cudart-dev-${CUDA_SHORT/./-} cuda-cufft-dev-${CUDA_SHORT/./-} cuda-cusparse-dev-${CUDA_SHORT/./-}
    sudo apt clean
    export CUDA_HOME=/usr/local/cuda-${CUDA_SHORT}
    export LD_LIBRARY_PATH=${CUDA_HOME}/lib64:${LD_LIBRARY_PATH}
    export PATH=${CUDA_HOME}/bin:${PATH}
    cmake ..
    ;;
osx)
   ;;
windows)
    choco install cuda
    export PATH=${MSBUILD_PATH}:$PATH
    export CUDA_HOME="c:\Program Files\NVIDIA GPU Computing Toolkit\CUDA\v10.1"
    ls $CUDA_HOME
    export CUDA_ROOT_TOOLKIT_DIR=$CUDA_HOME
    cmake -DCMAKE_WINDOWS_EXPORT_ALL_SYMBOLS=TRUE -DBUILD_SHARED_LIBS=TRUE -G "Visual Studio 14 2015 Win64" ..
    choco install python --version=3.6.3
    python -m pip install --upgrade pip
    pip install wheel
    ;;
esac

cmake --build .
cd ../python
python setup.py bdist_wheel
