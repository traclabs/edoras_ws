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
