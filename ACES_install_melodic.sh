NC=$'\e[0m'
Orange=$'\e[0;33m'
Red=$'\e[0;31m'
Green=$'\e[0;32m'

echo -e "${Green}This script installs the dependences and requrements to run the ACES system and simulations."
echo -e "${Green}This script was written for Ubuntu 20.04, and ROS melodic."
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
sudo apt install -y ros-melodic-teleop-twist-keyboard ros-melodic-multirobot-map-merge ros-melodic-explore-lite ros-melodic-navigation ros-melodic-octomap ros-melodic-octomap-mapping ros-melodic-octomap-msgs ros-melodic-octomap-ros ros-melodic-octomap-rviz-plugins ros-melodic-octomap-server
cp -r .gazebo ~
cd src
git clone https://github.com/hrnr/map-merge
git clone https://github.com/appliedAI-Initiative/orb_slam_2_ros.git
echo "catkin_package()" | sudo tee -a map-merge/map_merge_3d/CMakeLists.txt
cd ..
echo -e "${Green}Installation complete. Please run catkin_make to compile the ACES components"
