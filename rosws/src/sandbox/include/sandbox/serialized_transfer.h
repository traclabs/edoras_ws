#include <rclcpp/rclcpp.hpp>
#include <ff_msgs/msg/odometry.hpp>

namespace edoras
{

/**
 * @class SerializedTransfer
 */
class SerializedTransfer : public rclcpp::Node {

  public:

  SerializedTransfer();

  protected:
  void cb_odom(const ff_msgs::msg::Odometry::SharedPtr _msg);

  rclcpp::Subscription<ff_msgs::msg::Odometry>::SharedPtr sub_odom_;
  
}; // class SerializedTransfer

} // namespace edoras
