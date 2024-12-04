#!/usr/bin/env bash

clone_cfs() {
  echo "Cloning cFS"
  git clone -b main git@github.com:traclabs/cFS.git
  pushd cFS
  git submodule update --init --recursive
  popd
  echo "Cloning gateway app"
  git clone -b master git@github.com:traclabs/gateway_app.git cFS/apps/gateway_app
}

echo ""
echo "##### Clone cFS #####"
echo ""
clone_cfs 

