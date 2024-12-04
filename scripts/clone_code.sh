#!/usr/bin/env bash

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
  git clone -b master git@github.com:traclabs/gateway_app.git cFS/apps/gateway_app
}

clone_edoras() {

  if [ -d "edoras" ]
  then
    echo "* Directory edoras already exists, not cloning"
    return 1
  fi

  echo "* Cloning edoras metapackage... "
  git clone -b master git@github.com:traclabs/edoras edoras
}

echo ""
echo "##### Clone cFS #####"
echo ""
clone_cfs 

echo ""
echo "##### Clone edoras workspace #####"
echo ""
clone_edoras 


