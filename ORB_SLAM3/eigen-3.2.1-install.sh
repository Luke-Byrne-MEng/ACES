version="3.2.1"
eigen="eigen-$version"

echo "Installing Dependenices"
sudo apt-get -y install build-essential checkinstall cmake pkg-config yasm

echo "Downloading $eigen"
mkdir $eigen
cd $eigen
wget -O $eigen.tar.bz2 https://gitlab.com/libeigen/eigen/-/archive/3.2.10/eigen-3.2.10.tar.bz2
mkdir $eigen
tar --strip-components=1 -xvjf $eigen.tar.bz2 -C $eigen

echo "Installing $eigen"
cd $eigen
mkdir build
cd build
cmake .. 
make
sudo make install
echo "Finished: $eigen is ready to be used"
