Run Gateway single-arm example
=================================

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
   ros2 launch edoras_demos gateway_single_arm_flight_demo_multihost.launch.py 
   ```
   
4. Open a terminal in rosgsw:
   
   ```
   docker exec -it edoras_ws-rosgsw-1 bash
   cd /code/edoras
    ros2 launch edoras_demos gateway_single_arm_ground_demo_multihost.launch.py
   ```

5. In the browser with VNC, move the gimbals, right click and send a target pose. You should see the robot being simulated on the flight side move. On the ground side (the Rviz window where the gimbals show up), you should see the robot moving, but at a slower pace, given that the telemetry is coming back at a slower rate. If you look at the terminals' output, you'll see some communication output.

