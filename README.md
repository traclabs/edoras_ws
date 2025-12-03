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
   ./scripts/build_rosws.sh
   ```

Run Gateway example
====================

1. Start services:
   ```
   docker compose -f docker-compose-dev.yml up
   ```
   This will start 3 services: fsw, rosgsw and novnc. fsw starts cFS already up

2. In a browser open VNC: http://localhost:8080/vnc.html
   
3. Open a terminal in rosfsw, launch robot on the flight side:
   
   ```
   docker exec -it edoras_ws-rosfsw-1 bash
   cd /code/edoras
   ros2 launch edoras_demos gateway_dual_flight_demo_multihost.launch.py
   ```
   
4. Open a terminal in rosgsw:
   
   ```
   docker exec -it edoras_ws-rosgsw-1 bash
   cd /code/edoras
   ros2 launch edoras_demos gateway_dual_ground_demo_multihost.launch.py
   ```

5. In the browser with VNC, move the gimbals, right click and send a target pose. You should see the robot being simulated on the flight side move. On the ground side (the Rviz window where the gimbals show up), you should see the robot moving, but at a slower pace, given that the telemetry is coming back at a slower rate. If you look at the terminals' output, you'll see some communication output.

Run Rover example
=================

Pre-requisite:
---------------
For the rover example, you'll have to change two branches:

* In cFS: Switch to branch *edoras*
* In edoras_app (located in cFS/apps/edoras_app): Switch to *master*
* Rebuild cFS:
  ```
  cd ~/edoras_ws
  ./scripts/build_cfe.sh
  ```
  By default, cFS and edoras_app are cloned in the branches used for running the Gateway dual setup.

Steps
------

1. Start services:
   ```
   docker compose -f docker-compose-dev.yml up
   ```
   This will start 3 services: fsw, rosgsw and novnc. fsw starts cFS already up.
   
2. In a browser open VNC: http://localhost:8080/vnc.html

3. Open a terminal in rosfsw, launch robot on the flight side:

   ```
   docker exec -it edoras_ws-rosfsw-1 bash
   cd /code/edoras
   ros2 launch edoras_demos rover_flight_demo_multihost.launch.py
   ```

4. Open a terminal in rosgsw:

   ```
   docker exec -it edoras_ws-rosgsw-1 bash
   cd /code/edoras
   ros2 launch edoras_demos rover_ground_demo_multihost.launch.py
   ```
5. In the browser, you can use the RQT Steering GUI (in the ground side) to send a command to the robot on the flight side. You'll see the telemetry being sent back to the ground with the red arrow moving. The robot simulated in Mars is running on the flight side.   
