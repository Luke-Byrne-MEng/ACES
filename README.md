# ACES
2020/2021 GCU Masters project for Luke Byrne, Ryan Walker, Mateo Alvares, Jamie Hardie, and Kamil Shabkhez.

The ACES (Automated Colaborative Exploration Swarm) system is a comprehensive multi-robot mapping system that uses cutting edge CSLAM and swarm navigation methods. This system is modeled and simulated in the Gazebo environment, and uses the ROS middleware.

**This project is still in development, and therefore further documentation will be coming.**

This project has been developed and optimised for **Ubuntu 20.04** with **ROS Noetic**. However it should be simple to edit the install script to use other distros and ROS versions.

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
## 4.1 ROS Launch File Parameters
Each of the ROS packages used in this project have their own parameters within the provided launch files. These launch files work as-is, but further configuration is possible. Please see the respective ROS wiki pages for each package, for a more complete discription of their configuration and operation.

### 4.1.1 orb_slam_2_ros
- **load_map**: Bool. If set to true, the node will try to load the map provided with map_file at startup.
- **map_file**: String. The name of the file the map is loaded from.
- **voc_file**: String. The location of config vocanulary file mentioned above.
- **publish_pointcloud**: Bool. If the pointcloud containing all key points (the map) should be published.
- **publish_pose**: Bool. If a PoseStamped message should be published. Even if this is false the tf will still be published.
- **pointcloud_frame_id**: String. The Frame id of the Pointcloud/map.
- **camera_frame_id**: String. The Frame id of the camera position.
- **target_frame_id**: String. Map transform and pose estimate will be provided in this frame id if set.
- **load_calibration_from_cam**: Bool. If true, camera calibration is read from a `camera_info` topic. Otherwise it is read from launch file params.


### 4.1.2 octomap_server
- **frame_id**: String. Static global frame in which the map will be published. A transform from sensor data to this frame needs to be available when dynamically building maps. 
- **resolution**: Float. Resolution in meter for the map when starting with an empty map. Otherwise the loaded file's resolution is used. 
- **base_frame_id**: String. The robot's base frame in which ground plane detection is performed (if enabled) 
- **height_map**: Bool. Whether visualization should encode height with different colors 
- **color/[r/g/b/a]**: Float. Color for visualizing occupied cells when ~heigh_map=False, in range [0:1] 
- **sensor_model/max_range**: Float. Maximum range in meter for inserting point cloud data when dynamically building a map. Limiting the range to something useful (e.g. 5m) prevents spurious erroneous points far away from the robot. 
- **sensor_model/[hit|miss]**: Float. Probabilities for hits and misses in the sensor model when dynamically building a map 
- **sensor_model/[min|max]**: Float. Minimum and maximum probability for clamping when dynamically building a map 
- **latch**: Bool. Whether topics are published latched or only once per change. For maximum performance when building a map (with frequent updates), set to false. When set to true, on every map change all topics and visualizations will be created. 
- **filter_ground**: Bool. Whether the ground plane should be detected and ignored from scan data when dynamically building a map, using pcl::SACMODEL_PERPENDICULAR_PLANE. This clears everything up to the ground, but will not insert the ground as obstacle in the map. If this is enabled, it can be further configured with the ~ground_filter/... parameters. 
- **ground_filter/distance**: Float. Distance threshold for points (in z direction) to be segmented to the ground plane 
- **ground_filter/angle**: Float. Angular threshold of the detected plane from the horizontal plane to be detected as ground 
- **ground_filter/plane_distance**: Float. Distance threshold from z=0 for a plane to be detected as ground (4th coefficient of the plane equation from PCL) 
- **pointcloud_[min|max]_z**: Float. Minimum and maximum height of points to consider for insertion in the callback. Any point outside of this intervall will be discarded before running any insertion or ground plane filtering. You can do a rough filtering based on height with this, but if you enable the ground_filter this interval needs to include the ground plane. 
- **occupancy_[min|max]_z**: Float. Minimum and maximum height of occupied cells to be consider in the final map. This ignores all occupied voxels outside of the interval when sending out visualizations and collision maps, but will not affect the actual octomap representation. 


### 4.1.3 explore_lite
- **robot_base_frame**: String. The name of the base frame of the robot. This is used for determining robot position on map. Mandatory. 
- **costmap_topic**: String. Specifies topic of source nav_msgs/OccupancyGrid. Mandatory. 
- **costmap_updates_topic**: String. Specifies topic of source map_msgs/OccupancyGridUpdate. Not necessary if source of map is always publishing full updates, i.e. does not provide this topic. 
- **visualize**: Bool. Specifies whether or not publish visualized frontiers. 
- **planner_frequency**: Double. Rate in Hz at which new frontiers will computed and goal reconsidered. 
- **progress_timeout**: Double. Time in seconds. When robot do not make any progress for progress_timeout, current goal will be abandoned. 
- **potential_scale**: Double. Used for weighting frontiers. This multiplicative parameter affects frontier potential component of the frontier weight (distance to frontier). 
- **orientation_scale**: Double. Used for weighting frontiers. This multiplicative parameter affects frontier orientation component of the frontier weight. This parameter does currently nothing and is provided solely for forward compatibility. 
- **gain_scale**: Double. Used for weighting frontiers. This multiplicative parameter affects frontier gain component of the frontier weight (frontier size). 
- **transform_tolerance**: Double. Transform tolerance to use when transforming robot pose. 
- **min_frontier_size**: Double. Minimum size of the frontier to consider the frontier as the exploration goal. In meters. 

### 4.1.4 move_base
- **base_global_planner** String. The name of the plugin for the global planner to use with move_base, see pluginlib documentation for more details on plugins. This plugin must adhere to the nav_core::BaseGlobalPlanner interface specified in the nav_core package. (1.0 series default: "NavfnROS") 
- **base_local_planner** String. The name of the plugin for the local planner to use with move_base see pluginlib documentation for more details on plugins. This plugin must adhere to the nav_core::BaseLocalPlanner interface specified in the nav_core package. (1.0 series default: "TrajectoryPlannerROS") 
- **recovery_behaviors** List. A list of recovery behavior plugins to use with move_base, see pluginlib documentation for more details on plugins. These behaviors will be run when move_base fails to find a valid plan in the order that they are specified. After each behavior completes, move_base will attempt to make a plan. If planning is successful, move_base will continue normal operation. Otherwise, the next recovery behavior in the list will be executed. These plugins must adhere to the nav_core::RecoveryBehavior interface specified in the nav_core package. (1.0 series default: [{name: conservative_reset, type: ClearCostmapRecovery}, {name: rotate_recovery, type: RotateRecovery}, {name: aggressive_reset, type: ClearCostmapRecovery}]). Note: For the default parameters, the aggressive_reset behavior will clear out to a distance of 4 * ~/local_costmap/circumscribed_radius. 
- **controller_frequency** Double. The rate in Hz at which to run the control loop and send velocity commands to the base. 
- **planner_patience** Double. How long the planner will wait in seconds in an attempt to find a valid plan before space-clearing operations are performed. 
- **controller_patience** Double. How long the controller will wait in seconds without receiving a valid control before space-clearing operations are performed. 
- **conservative_reset_dist** Double. The distance away from the robot in meters beyond which obstacles will be cleared from the costmap when attempting to clear space in the map. Note, this parameter is only used when the default recovery behaviors are used for move_base. 
- **recovery_behavior_enabled** Bool. Whether or not to enable the move_base recovery behaviors to attempt to clear out space. 
- **clearing_rotation_allowed** Bool. Determines whether or not the robot will attempt an in-place rotation when attempting to clear out space. Note: This parameter is only used when the default recovery behaviors are in use, meaning the user has not set the recovery_behaviors parameter to anything custom. 
- **shutdown_costmaps** Bool. Determines whether or not to shutdown the costmaps of the node when move_base is in an inactive state 
- **oscillation_timeout** Double. How long in seconds to allow for oscillation before executing recovery behaviors. A value of 0.0 corresponds to an infinite timeout. New in navigation 1.3.1 
- **oscillation_distance** Double. How far in meters the robot must move to be considered not to be oscillating. Moving this far resets the timer counting up to the ~oscillation_timeout New in navigation 1.3.1 
- **planner_frequency** Double. The rate in Hz at which to run the global planning loop. If the frequency is set to 0.0, the global planner will only run when a new goal is received or the local planner reports that its path is blocked. New in navigation 1.6.0 
- **max_planning_retries** Int. How many times to allow for planning retries before executing recovery behaviors. A value of -1.0 corresponds to an infinite retries.

### 4.1.5 map_merge_3d (also called map_merge)
- **robot_map_topic** String. Name of robot map topic without namespaces (last component of the topic name). Only topics with this name are considered when looking for new maps to merge. This topics may be subject to further filtering (see below). 
- **robot_namespace** String. Fixed part of the robot map topic. You can employ this parameter to further limit which topics are considered during dynamic lookup for robots. Only topics which contain (anywhere) this string are considered for lookup. Unlike robot_map_topic you are not limited by namespace logic. Topics are filtered using text-based search. Therefore robot_namespace does not need to be a ROS namespace, but it can contain slashes etc. This string must be a common part of all maps topic name (all robots for which you want to merge map). 
- **merged_map_topic** String. Topic name where merged map is published. 
- **world_frame** String. Frame id (in tf tree) which is assigned to published merged map and used as reference frame for tf transforms. 
- **compositing_rate** Double. Rate in Hz. Basic frequency on which the node merges maps and publishes merged map. Increase this value if you want faster updates. 
- **discovery_rate** Double. Rate in Hz. Frequency on which this node discovers new robots (maps). Increase this value if you need more agile behaviour when adding new robots. 
- **estimation_rate** Double. Rate in Hz. Frequency on which this node re-estimates transformations between maps. Estimation is cpu-intensive, so you may wish to lower this value. 
- **publish_tf** Bool. Whether to publish estimated transforms in the tf tree. See below. 
- **resolution** Double. Resolution used for the registration. Small value increases registration time. 
- **descriptor_radius** Double. Radius for descriptors computation. 
- **outliers_min_neighbours** Int. Minimum number of neighbours for a point to be kept in the map during outliers pruning. 
- **normal_radius** Double. Radius used for estimating normals. 
- **keypoint_type** String. Type of keypoints used. Possible values are SIFT, HARRIS. 
- **keypoint_threshold** Double. Keypoints with lower response that this value are pruned. Lower this threshold when using Harris keypoints (you can set 0.0). 
- **descriptor_type** String. Type of descriptors used. Possible values are PFH, PFHRGB, FPFH, RSD, SHOT, SC3D. 
- **estimation_method** String. Type of descriptors matching algorithm used. This algorithm is used for initial global match. Possible values are MATCHING, SAC_IA. 
- **refine_transform** Bool. Whether to refine estimated transformation with ICP or not. 
- **inlier_threshold** Double. Inlier threshold used in RANSAC during estimation. 
- **max_correspondence_distance** Double. Maximum distance for matched points to be considered the same point. 
- **max_iterations** Int. Maximum iterations for RANSAC. 
- **matching_k** Int. Number of the nearest descriptors to consider for matching. 
- **transform_epsilon** Double. The smallest change allowed until ICP convergence. 
- **confidence_threshold** Double. Minimum confidence in the pair-wise transform estimate to be included in the map-merging graph. Pair-wise transformations with lower confidence are not considered when computing global transforms. Increase this value if you are having problems with invalid transforms being estimated. The confidence value is computed as a reciprocal of Euclidean distance between transformed maps. 
- **output_resolution** Double. Resolution of the merged global map. 

## 4.2 Gazebo configuration


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




