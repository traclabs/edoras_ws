#!/bin/bash
 
# Source ROS 2
source /opt/ros/jazzy/setup.bash
 
if [ -f /code/edoras/install/setup.bash ]
then
  source /code/edoras/install/setup.bash
fi
  
# Execute the command passed into this entrypoint
exec "$@"
