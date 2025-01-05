# edoras
Edoras: Closing the loop to bridge CFS and ROS2

Building docker images
=======================

1. Clone this repository:
   ```
   git clone git@github.com:traclabs/edoras_ws.git
   cd edoras_ws
   ```

2. Clone software (cFS and edoras workspace)
   ```
   ./scripts/clone_code.sh
   ```
3. Build base images:
   ```
   ./scripts/build_images.sh
   ```
4. Build cFS and edoras ROS2 workspace:
   ```
   ./scripts/build_cfe.sh
   ./scripts/build_edoras.sh
   ```
Run Rover example
=================

1. Start services:
   ```
   docker compose -f docker-compose-dev.yml up
   ```
   This will start 3 services: fsw, rosgsw and novnc. fsw starts cFS already
2. Open a terminal in fsw, launch robot on the flight side:
   ```
   docker exec -it edoras_ws-fsw-1 bash
   ```
   Inside the container:
   ```
   cd /code/edoras
   source install/setup.bash
   ros2 launch edoras_demos rover_flight_demo.launch.py
   ```
3. Open a terminal in rosgsw:
   ```
   docker exec -it edoras_ws-rosgsw-1 bash
   ```
   Inside the container:
   ```
   cd /code/edoras
   source install/setup.bash
   ros2 launch edoras_demos rover_ground_demo.launch.py
