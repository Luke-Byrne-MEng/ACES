NC=$'\e[0m'
Orange=$'\e[0;33m'
Red=$'\033[0;31m'

echo -e "${Red}Installing dependencies for ORB_SLAM3 and Pangolin viewer ${NC}"
echo -e ""
sudo apt update
sudo apt install -y python3-dev python3-pip python3-opencv libgl1-mesa-dev libglew-dev libpython2.7-dev libwayland-dev libxkbcommon-dev wayland-protocols ffmpeg libavcodec-dev libavutil-dev libavformat-dev libswscale-dev libavdevice-dev build-essential libssl-dev libffi-dev ros-noetic-teleop-twist-keyboard ros-noetic-octomap
#sudo python -mpip install numpy 
sudo python3 -mpip install numpy pyopengl Pillow pybind11

echo "${Orange}Building Pangolin viewer${NC}"
cd Pangolin
mkdir build
cd build
cmake ..
cmake --build .
cd ../..

echo "${Orange}Installing Eigen 3.2.10${NC}"
cd eigen-3.2.10
mkdir build
cd build
cmake ..
sudo make install
cd ../..

echo "${Orange}exporting ${Red}ROS_PACKAGE_PATH ${Orange}as ${Red}~/ORB_SLAM3/Examples/ROS${NC}"
echo "${Orange}please edit ${Red}~/.bashrc ${Orange}if this is not appropriate${NC}"
echo 'export ROS_PACKAGE_PATH=${ROS_PACKAGE_PATH}:~/ORB_SLAM3/Examples/ROS' >> ~/.bashrc 

