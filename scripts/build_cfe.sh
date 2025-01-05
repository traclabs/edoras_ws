#!/usr/bin/env bash

echo ""
echo "##### Building cfe #####"
echo ""
COMPOSE_FILE="docker-compose-dev.yml"
CODE_DIR="/code"

build_edoras_core() {
  docker compose -f ${COMPOSE_FILE} run -w ${CODE_DIR}/edoras_core fsw /bin/bash  -ic "mkdir -p build && mkdir -p install && \
                     cd build && source /opt/ros/jazzy/setup.bash && \
                     cmake .. -DCMAKE_INSTALL_PREFIX=../install && \
                     make && make install" 
}

build_cfe_code() {

  docker compose -f ${COMPOSE_FILE} run -w ${CODE_DIR}/cFS fsw make SIMULATION=native prep
  ret=$?
  if [ $ret -ne 0 ]; then
    echo "!! Failed in make SIMULATION step !!"
    return 1  
  fi

  docker compose -f ${COMPOSE_FILE} run -w ${CODE_DIR}/cFS fsw make
  ret=$? 
  if [ $ret -ne 0 ]; then
    echo "!! Failed in make step !!"
    return 1
  fi

  docker compose -f ${COMPOSE_FILE} run -w ${CODE_DIR}/cFS fsw make install
  ret=$?
  if [ $ret -ne 0 ]; then
    echo "!! Failed in make install step !!"
    return 1  
  fi

  echo "Create linking to edoras_core in cpu1/cf and cpu2/cf"
  docker compose -f ${COMPOSE_FILE} run -w ${CODE_DIR}/cFS fsw /bin/bash -ic "rm ${CODE_DIR}/cFS/build/exe/cpu1/cf/libedoras_core.so"
  docker compose -f ${COMPOSE_FILE} run -w ${CODE_DIR}/cFS fsw /bin/bash -ic "rm ${CODE_DIR}/cFS/build/exe/cpu2/cf/libedoras_core.so" 
  docker compose -f ${COMPOSE_FILE} run -w ${CODE_DIR}/cFS fsw /bin/bash -ic "ln -s ${CODE_DIR}/edoras_core/install/lib/libedoras_core.so ${CODE_DIR}/cFS/build/exe/cpu1/cf/libedoras_core.so"  
  docker compose -f ${COMPOSE_FILE} run -w ${CODE_DIR}/cFS fsw /bin/bash -ic "ln -s ${CODE_DIR}/edoras_core/install/lib/libedoras_core.so ${CODE_DIR}/cFS/build/exe/cpu2/cf/libedoras_core.so" 
  
  echo ""
  echo "##### Done! #####"
  return 0
}

build_edoras_core
build_cfe_code
