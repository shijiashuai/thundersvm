#!/bin/bash

set -x

mkdir build
cd build

case ${TRAVIS_OS_NAME} in
linux)
    INSTALLER=cuda-repo-${UBUNTU_VERSION}_${CUDA}_amd64.deb
    wget -q http://developer.download.nvidia.com/compute/cuda/repos/${UBUNTU_VERSION}/x86_64/${INSTALLER}
    sudo dpkg -i ${INSTALLER}
    wget https://developer.download.nvidia.com/compute/cuda/repos/${UBUNTU_VERSION}/x86_64/7fa2af80.pub
    sudo apt-key add 7fa2af80.pub
    sudo apt update -qq
    sudo apt install -y cuda-core-${CUDA_SHORT/./-} cuda-cudart-dev-${CUDA_SHORT/./-} cuda-cusparse-dev-${CUDA_SHORT/./-}
    sudo apt clean
    export CUDA_HOME=/usr/local/cuda-${CUDA_SHORT}
    export LD_LIBRARY_PATH=${CUDA_HOME}/lib64:${LD_LIBRARY_PATH}
    export PATH=${CUDA_HOME}/bin:${PATH}
    cmake ..
    ;;
osx)
   ;;
windows)
#    wget -q http://developer.download.nvidia.com/compute/cuda/10.1/Prod/local_installers/cuda_10.1.243_426.00_win10.exe
#    ./cuda_10.1.243_426.00_win10.exe -s nvcc_10.1 cusparse_dev_10.1 cudart_10.1 visual_studio_integration_10.1
    choco install cuda
    export PATH=${MSBUILD_PATH}:$PATH
    CUDA_HOME="/c/Program Files/NVIDIA GPU Computing Toolkit/CUDA/v10.1"
    cat "/c/ProgramData/chocolatey/logs/chocolatey.log"
    echo  "1"
    ls "/c/Program Files"
    echo  "2"
    ls "/c/Program Files/NVIDIA GPU Computing Toolkit/CUDA"
    cmake -DCMAKE_WINDOWS_EXPORT_ALL_SYMBOLS=TRUE -DBUILD_SHARED_LIBS=TRUE -DCUDA_TOOLKIT_ROOT_DIR=${CUDA_HOME} -G "Visual Studio 14 2015 Win64" ..
    choco install python --version=3.6.3
    python -m pip install --upgrade pip
    pip install wheel
    ;;
esac

cmake --build .
cd ../python
python setup.py bdist_wheel
