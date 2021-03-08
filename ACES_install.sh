NC=$'\e[0m'
Orange=$'\e[0;33m'
Red=$'\e[0;31m'
Green=$'\e[0;32m'

echo -e "${Green}This script installs the dependences and requrements to run the ACES simulations."
echo -e "${Green}This script was written for Ubuntu 20, and ROS noetic."
echo -e "${Green}Please exit, and edit this script if using different versions of Ubuntu / ROS."
sleep 15
echo -e ""
echo -e ""
echo -e "${Orange}Installing dependencies."
echo -e ""
sleep 2
sudo apt update
sudo apt install -y python3-dev python3-pip python3-opencv libgl1-mesa-dev libglew-dev libpython2.7-dev libwayland-dev libxkbcommon-dev wayland-protocols ffmpeg libavcodec-dev libavutil-dev libavformat-dev libswscale-dev libavdevice-dev build-essential libssl-dev libffi-dev libeigen3-dev
sudo python3 -mpip install numpy pyopengl Pillow pybind11
echo -e ""
echo -e ""
echo -e "${Orange}Installing the ORB_SLAM2 ROS wrapper, explore_lite, multirobot_map_merge, the navigation stack, and octomap_server${NC}"
echo -e ""
sleep 4
sudo apt install -y ros-noetic-teleop-twist-keyboard ros-noetic-octomap ros-noetic-multirobot-map-merge ros-noetic-explore-lite ros-noetic-navigation
cd src
git clone https://github.com/appliedAI-Initiative/orb_slam_2_ros.git
git clone https://github.com/hrnr/map-merge
>> "catkin_package()" map-merge/map_merge_3d/CMakeLists.txt
cd ../..
cp -r .gazebo ~

