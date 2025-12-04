Run Rover example
=================

Pre-requisite:
---------------
For the rover example, you'll have to change two branches:

* In cFS: Switch to branch *edoras*
* In edoras_app (located in cFS/apps/edoras_app): Switch to *edoras_rover*
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

