# ACES
2020/2021 GCU Masters project for Luke Byrne, Ryan Walker, Mateo Alvares, Jamie Hardie, and Kamil Shabkhez.

The ACES (Automated Colaborative Exploration Swarm) system is a comprehensive multi-robot mapping system that uses cutting edge CSLAM and swarm navigation methods. This system is modeled and simulated in the Gazebo environment, and runs all code on ROS / ROS2.

**This project is still in development, and therefore further documentation will be coming.**

This project has been developed and optimised for **Ubuntu 20.04** with **ROS Noetic**. However it should be simple to edit the install script to use other distros and ROS versions.

# 1. Dependencies
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

# 2. Installation
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

# 3. Configuration
## 3.1 Launch File Parameters
There are three types of parameters right now: static- and dynamic ros parameters and camera settings.
The static parameters are send to the ROS parameter server at startup and are not supposed to change. They are set in the launch files which are located at ros/launch. The parameters are:

- **load_map**: Bool. If set to true, the node will try to load the map provided with map_file at startup.
- **map_file**: String. The name of the file the map is loaded from.
- **voc_file**: String. The location of config vocanulary file mentioned above.
- **publish_pointcloud**: Bool. If the pointcloud containing all key points (the map) should be published.
- **publish_pose**: Bool. If a PoseStamped message should be published. Even if this is false the tf will still be published.
- **pointcloud_frame_id**: String. The Frame id of the Pointcloud/map.
- **camera_frame_id**: String. The Frame id of the camera position.
- **target_frame_id**: String. Map transform and pose estimate will be provided in this frame id if set.
- **load_calibration_from_cam**: Bool. If true, camera calibration is read from a `camera_info` topic. Otherwise it is read from launch file params.

Dynamic parameters can be changed at runtime. Either by updating them directly via the command line or by using [rqt_reconfigure](http://wiki.ros.org/rqt_reconfigure) which is the recommended way.
The parameters are:

- **localize_only**: Bool. Toggle from/to only localization. The SLAM will then no longer add no new points to the map.
- **reset_map**: Bool. Set to true to erase the map and start new. After reset the parameter will automatically update back to false.
- **min_num_kf_in_map**: Int. Number of key frames a map has to have to not get reset after tracking is lost.
- **min_observations_for_ros_map**: Int. Number of minimal observations a key point must have to be published in the point cloud. This doesn't influence the behavior of the SLAM itself at all.

Finally, the intrinsic camera calibration parameters along with some hyperparameters can be found in the specific yaml files in orb_slam2/config.

# 4. Ros Topics

## 4.1 Subscribed topics
- The mono node subscribes to:
    - **/camera/image_raw** for the input image
    - **/camera/camera_info** for camera calibration (if `load_calibration_from_cam`) is `true`

- The RGBD node subscribes to:
    - **/camera/rgb/image_raw** for the RGB image
    - **/camera/depth_registered/image_raw** for the depth information
    - **/camera/rgb/camera_info** for camera calibration (if `load_calibration_from_cam`) is `true`

- The stereo node subscribes to:
    - **image_left/image_color_rect** and
    - **image_right/image_color_rect** for corresponding images
    - **image_left/camera_info** for camera calibration (if `load_calibration_from_cam`) is `true`

## 4.2 Published topics
The following topics are being published and subscribed to by the nodes:
- All nodes publish (given the settings) a **PointCloud2** containing all key points of the map.
- Also all nodes publish (given the settings) a **PoseStamped** with the current pose of the camera frame, or the target frame if `target_frame_id` is set.
- Live **image** from the camera containing the currently found key points and a status text.
- A **tf** from the pointcloud frame id to the camera frame id (the position), or the target frame if `target_frame_id` is set.

## 4.3 ROS Services
All nodes offer the possibility to save the map via the service node_type/save_map.
So the save_map services are:
- **/orb_slam2_rgbd/save_map**
- **/orb_slam2_mono/save_map**
- **/orb_slam2_stereo/save_map**

The save_map service expects the name of the file the map should be saved at as input.

At the moment, while the save to file takes place, the SLAM is inactive.


# 5. Running
After sourcing your setup bash using
```
source devel/setup.bash
```
you can launch one of the simulations using:
 - roslaunch multi_robot Office_with_3_robots.launch
 - roslaunch multi_robot SLAM.launch




