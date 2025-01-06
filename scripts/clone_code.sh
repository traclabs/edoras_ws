#!/usr/bin/env bash

EDORAS_APP_BRANCH="master"
EDORAS_CORE_BRANCH="humble"
EDORAS_BRANCH="humble"
SPOT_BRANCH="humble" #"SpaceROS-Challenge"

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
  git clone -b edoras git@github.com:traclabs/cFS.git
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
  git clone -b $EDORAS_CORE_BRANCH git@github.com:traclabs/edoras_core.git edoras_core
}


# *******************
# clone_edoras
# *******************
clone_edoras() {

  if [ ! -d "edoras" ]; then
    echo "* Cloning edoras metapackage... "
    git clone -b $EDORAS_BRANCH git@github.com:traclabs/edoras.git edoras
  fi

  echo "* Cloning champ code...*"

  pushd edoras
  pushd src
 
  if [ ! -d "spot_ros2_ign" ]; then
    git clone -b $SPOT_BRANCH git@github.com:traclabs/spot_ros2_ign.git
  fi
  
  if [ ! -d "trac_ik" ]; then
    git clone -b rolling-devel git@bitbucket.org:traclabs/trac_ik
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

