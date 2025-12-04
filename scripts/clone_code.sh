#!/usr/bin/env bash

EDORAS_APP_BRANCH="edoras_gateway_dual_arm"
CFS_BRANCH="edoras_dual_robot_demo"
ROS_WS="rosws"

# *******************
# clone_cfs
# *******************
clone_cfs() {

  if [ -d "cFS" ]
  then
    echo "* Directory cFS already exists, not cloning"
    return 1
  fi

  echo "* Cloning cFS..."
  git clone -b $CFS_BRANCH git@github.com:traclabs/cFS.git
  pushd cFS
  git submodule update --init --recursive
  popd
  echo "* Cloning gateway app..."
  git clone -b $EDORAS_APP_BRANCH git@github.com:traclabs/edoras_app.git cFS/apps/edoras_app
}

# *******************
# clone_edoras_code
# *******************
clone_edoras_code() {

  if [ -d "edoras_core" ]
  then
    echo "* Directory edoras_core already exists, not cloning"
    return 1
  fi

  echo "* Cloning edoras_core... "
  git clone -b master git@github.com:traclabs/edoras_core.git edoras_core
}


# *******************
# clone_edoras
# *******************
clone_edoras() {

  if [ ! -d $ROSWS ]; then
    mkdir $ROSWS
  fi
  
  pushd rosws
  if [ ! -d "src" ]; then
    mkdir src
  fi
  
  pushd src
  if [ ! -d "edoras" ]; then
    echo "* Cloning edoras metapackage... "
    git clone -b master git@github.com:traclabs/edoras.git
  fi

  popd
  popd  
}

# ************************
# clone_extra_robots
# ************************
clone_extra_robots() {

  pushd $ROSWS
  pushd src

  echo "* Cloning additional robots for demos...*"

  if [ ! -d "gateway_demos" ]; then
    git clone -b master git@github.com:traclabs/gateway_demos.git gateway_demos
  fi
  if [ ! -d "simulation" ]; then
    git clone -b main git@github.com:space-ros/simulation.git simulation
  fi
  if [ ! -d "demos" ]; then
    git clone -b pull_33 git@github.com:traclabs/demos.git demos
  fi
  if [ ! -d "roverrobotics_ros2" ]; then
    git clone -b main git@github.com:RoverRobotics/roverrobotics_ros2
  fi  
  if [ ! -d "trac_ik" ]; then
    git clone -b jazzy git@bitbucket.org:traclabs/trac_ik
  fi
  touch trac_ik/trac_ik_kinematics_plugin/COLCON_IGNORE
  
  popd
  popd
}


echo ""
echo "##### Clone cFS #####"
echo ""
clone_cfs 
	
echo ""
echo "##### Clone edoras_code library #####"
echo ""
clone_edoras_code 

echo ""
echo "##### Clone edoras workspace #####"
echo ""
clone_edoras

# Default mode=include_robots
mode="include_robots" # skip_robots

if [[$# -eq 1]]; then
  mode = $1
fi
  
if [[mode -eq "include_robots"]]; then   

  echo ""
  echo "##### Clone extra robots #####"
  echo ""
  clone_extra_robots
fi  
  
exit 1
