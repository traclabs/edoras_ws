cmake_minimum_required(VERSION 3.8)
project(sandbox)

if(CMAKE_COMPILER_IS_GNUCXX OR CMAKE_CXX_COMPILER_ID MATCHES "Clang")
  add_compile_options(-Wall -Wextra -Wpedantic)
endif()

# find dependencies
find_package(ament_cmake REQUIRED)

set(DEPS
  rclcpp
  ff_msgs
)

foreach(dependency IN ITEMS ${DEPS})
find_package(${dependency} REQUIRED)
endforeach()

include_directories(include)


add_library(serialized_transfer src/serialized_transfer.cpp)
#target_link_libraries(serialized_transfer task_ui)
ament_target_dependencies(serialized_transfer ${DEPS} )

#add_executable(serialized_transfer_node tools/serialized_transfer_node.cpp)
#target_link_libraries(task_ui_markers_node serialized_transfer)

#install(DIRECTORY launch config rviz urdf
#  DESTINATION share/${PROJECT_NAME}
#)

install(
  TARGETS serialized_transfer
#  serialized_transfer_node 
#  task_ui_markers_node
  ARCHIVE DESTINATION lib
  LIBRARY DESTINATION lib
  RUNTIME DESTINATION lib/${PROJECT_NAME}
  )      

ament_export_dependencies(${DEPS})

ament_export_include_directories(include)

if(BUILD_TESTING)
  find_package(ament_lint_auto REQUIRED)
  ament_lint_auto_find_test_dependencies()
endif()

ament_package()
