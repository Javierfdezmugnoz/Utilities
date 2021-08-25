#=================================
# Bash file to installing initial
# programs in ubuntu
#================================
# nano
sudo apt-get install nano

# Install python
sudo apt-get install software-properties-common
sudo add-apt-repository ppa:deadsnakes/ppa
sudo apt-get update
sudo apt-get install python3.8

# remove old cmake version
sudo apt remove --purge cmake
hash -r

# install cmake 3.20 (newest requires update the github repository
sudo apt install build-essential libssl-dev
wget https://github.com/Kitware/CMake/releases/download/v3.20.2/cmake-3.20.2.tar.gz
tar -zxvf cmake-3.20.2.tar.gz
cd cmake-3.20.2
./bootstrap
make
sudo make install

# Install locate
sudo apt install mlocate
sudo updatedb

# Install clang
sudo apt-get install clang-10
sudo ln -s /usr/bin/clang-10 /usr/bin/clang
sudo ln -s /usr/bin/clang++-10 /usr/bin/clang++

#============================
# Checking the installations
#============================
nano --version
python3.8 --version
cmake --version
mlocate --version
nvcc --version
clang --version
echo "if nvcc is not installed:"
echo "go to /home/username/ ,open .bashrc and copy these lines:"
echo "# Include nvcc path (Added by Javier Fdez)"
echo "export CUDA_HOME=/usr/local/cuda-10.2"
echo "export LD_LIBRARY_PATH=${CUDA_HOME}/lib64"
echo "PATH=${CUDA_HOME}/bin:${PATH}"
echo "export PATH"


echo "if you use .cu files go to this page: https://askubuntu.com/questions/400616/how-can-i-highlight-c-syntax-in-cuda-cu-files-in-nano";
