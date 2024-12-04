#!/usr/bin/env bash

echo ""
echo "##### Building edoras #####"
echo ""

COMPOSE_FILE="docker-compose-dev.yml"
CODE_DIR="/code"

# Build EDORAS workspace
build_edoras_code() {
  docker compose -f ${COMPOSE_FILE} run -w ${CODE_DIR}/edoras rosgsw colcon build --symlink-install
  ret=$?
  if [ $ret -ne 0 ]; then
    echo "!! Failed in colcon build step that builds edoras workspace !!"
    return 1  
  fi
  
  return 0
}

 
# Going...
echo "**** Building brash... ****"
build_edoras_code
edoras_res=$?

if [ $edoras_res -eq 1 ]; then
  exit 1
fi

   
echo ""
echo "##### Done! #####"
exit 0
