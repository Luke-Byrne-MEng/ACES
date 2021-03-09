# ACES
2020/2021 GCU Masters project for Luke Byrne, Ryan Walker, Mateo Alvares, Jamie Hardie, and Kamil Shabkhez.

The ACES (Automated Colaborative Exploration Swarm) system is a comprehensive multi-robot mapping system that uses cutting edge CSLAM and swarm navigation methods. This system is modeled and simulated in the Gazebo environment, and uses the ROS middleware.

**This project is still in development, and therefore further documentation will be coming.**

This project has been developed and optimised for **Ubuntu 20.04** with **ROS Noetic**. However it should be simple to edit the install script to use other distros and ROS versions.

## Table of Contents

- [System Structure](#1.-system-structure)
- [Dependencies](#2.-dependencies)
- [Installation](#3.-installation)
- [Configuration](#4.-configuration)
- [Ros Topics & Services](#5.-ros-topics-&-services)
- [Running](#6.-running)


# 1. System Structure
![System_block_diagram](https://github.com/Luke-Byrne-uni/ACES/blob/main/system1.png?raw=true)

The following ROS nodes are used within this project:
- ![orb_slam_2_mono](https://github.com/appliedAI-Initiative/orb_slam_2_ros) performing monocular SLAM
- ![octomap_server](http://wiki.ros.org/octomap_server) converting the SLAM point cloud into a 2D occupancy grid & making global map readable
- ![explore_lite](http://wiki.ros.org/explore_lite) using the occupancy grid to perform greedy fronteer exploration
- ![move_base](http://wiki.ros.org/move_base) to translate the eploration goals to movement commands
- ![map_merge_node](http://wiki.ros.org/map_merge_3d) collecting each robot's point cloud and merging them into a global map

These will all be installed via the ACES_install.sh script provided in this repo


# 2. Dependencies
These are the project dependencies. Other than ROS and Gazebo, everything will be installed automatically when running the install script.
If you would like to use different versions of these dependences then please edit the install script accordingly.
```
- ROS
- Gazebo
- python 3
- pip
- open cv
- lib gl
- lib glew
- wayland
- ffmpeg
- av util, format, codec, device
- sw scale
- build-essential
- ssl
- ffi
- eigen3
- numpy
- pyopengl
- pillow
- pybind11
```


# 3. Installation
Clone the repository into your catkin workspace /src/ folder:
```
git clone https://github.com/Luke-Byrne-uni/ACES.git
```
Then run the install script, and compile with catkin_make:
```
cd ACES
sudo bash ACES_install.sh
caktin_make
```


# 4. Configuration
Configuration of the ACES system, and of the Gazebo simulation is done via parameters in the ACES launch files. Although the system should work as-is, it is possible to edit these parameters to change system behaviour. A complete list, and discription, of system parameters is a vailable in the [ACES_config.md](https://github.com/Luke-Byrne-uni/ACES/blob/main/ACES_config.md) file.


# 5. Ros Topics & Services

## 5.1 Publisdhed Topics
### 5.1.1 obslam_2_ros_mono


### 5.1.2 octomap_server

### 5.1.3 explore_lite

### 5.1.4 octomap_server


## 5.2 ROS Services

- **/orb_slam2_mono/save_map** Saves a robot's local SLAM map. This service expects the name of the file the map should be saved at as input.


# 6. Running
After sourcing your setup.bash, by cd-ing into your catkin_ws and doing:
```
source devel/setup.bash
```
you can launch one of the simulations using:
```
 - roslaunch multi_robot Office_with_3_robots.launch
 - roslaunch multi_robot SLAM.launch
```




