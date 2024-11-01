
#include <sandbox/serialized_transfer.h>

namespace edoras
{

/**
 * @function SerializedTransfer
 * @brief Constructor
 */
SerializedTransfer::SerializedTransfer() :
 Node("minimal_publisher") {

  sub_odom_ = this->create_subscription<ff_msgs::msg::Odometry>("test_data_topic", 10, std::bind(&SerializedTransfer::cb_odom, this, std::placeholders::_1));

}


/**
 * @function cb_odom
 * @brief Callback when an Odometry message is received
 */
void cb_odom(const ff_msgs::msg::Odometry::SharedPtr _msg)
{
   // 1. Serialize mesage
   
   // 2. Add a message ID
   
   // 3. Publish it up to a topic
}


} // namespace edoras
