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
   ros2 launch edoras_demos rover_flight_demo.launch.py
   ```
3. Open a terminal in rosgsw:
   ```
   docker exec -it edoras_ws-rosgsw-1 bash
   ```
   Inside the container:
   ```
   cd /code/edoras
   ros2 launch edoras_demos rover_ground_demo_multihost.launch.py
   ```
4. Bridge are up on the ground, operator UI is setup on the ground, and cFS and the robot on the flight side are up. One last thing is needed: Let cFS know that we want telemetry data back:
   ```
   docker exec -it edoras_ws-rosgsw-1 bash
   ```

   ```
   cd /code/edoras
   ros2 service call /to_lab_enable_output_cmd std_srvs/srv/SetBool data:\ false\
   ```
   You'll see in the first terminal something like: Telemetry for IP: 10.5.0.3 activated. In the rosgsw's Rviz window, you'll see a red arrow show up, showing that telemetry from the rover is being received back.


Run Gateway example
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
   ros2 launch edoras_demos gateway_big_arm_flight_demo.launch.py
   ```
3. Open a terminal in rosgsw:
   ```
   docker exec -it edoras_ws-rosgsw-1 bash
   ```
   Inside the container:
   ```
   cd /code/edoras
   ros2 launch edoras_demos gateway_big_arm_ground_demo_multihost.launch.py
   ```
4. Bridge are up on the ground, operator UI is setup on the ground, and cFS and the robot on the flight side are up. One last thing is needed: Let cFS know that we want telemetry data back:
   ```
   docker exec -it edoras_ws-rosgsw-1 bash
   ```

   ```
   cd /code/edoras
   ros2 service call /to_lab_enable_output_cmd std_srvs/srv/SetBool data:\ false\
   ```
   You'll see in the first terminal something like: Telemetry for IP: 10.5.0.3 activated. In the rosgsw's Rviz window, you'll see a red arrow show up, showing that telemetry from the rover is being received back.

