#!/usr/bin/env bash

clone_cfs() {
  echo "Cloning cFS"
  git clone -b edoras git@github.com:traclabs/cFS.git
  pushd cFS
  git submodule update --init --recursive
  popd
  echo "Cloning gateway app"
  git clone -b master git@github.com:traclabs/gateway_app.git cFS/apps/gateway_app
}

clone_edoras {
  echo "Cloning edoras metapackage"
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


