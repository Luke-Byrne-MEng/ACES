Paste plugin before the last < /world > (adjust arguments according to the map): 
<plugin name='gazebo_occupancy_map' filename='libgazebo_2Dmap_plugin.so'>
    <map_resolution>0.1</map_resolution> <!-- in meters, optional, default 0.1 -->
    <map_height>0.3</map_height>         <!-- in meters, optional, default 0.3 -->
    <map_size_x>10</map_size_x>          <!-- in meters, optional, default 10 -->
    <map_size_y>10</map_size_y>          <!-- in meters, optional, default 10 -->
    <init_robot_x>0</init_robot_x>          <!-- x coordinate in meters, optional, default 0 -->
    <init_robot_y>0</init_robot_y>          <!-- y coordinate in meters, optional, default 0 -->
</plugin>

Install map server
sudo apt-get install ros-melodic-map-server

Launch world to be converted
roslaunch jet_gazebo jet_gazebo_Textured.launch


Run map server specifying output file name:
rosrun map_server map_saver -f Textured2 /map:=/map2d

Execute rosservice:
rosservice call /gazebo_2Dmap_plugin/generate_map

.pgm & .yaml files are generated in home

