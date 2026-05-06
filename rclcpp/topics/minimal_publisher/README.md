# Minimal Publisher Examples 

This package provides several minimal examples demonstrating how to implement
publisher nodes in ROS 2 using `rclcpp`.

These examples are designed as learning references for new ROS 2 developers
and illustrate different design patterns for publishing messages.

### member_function.cpp
Subclasses `rclcpp::Node` and uses a member function as the timer callback.

This pattern is commonly used in ROS 2 and supports node composition when nodes are structured as classes.

### lambda.cpp
Uses a C++ lambda function as the timer callback.

This approach is concise and suitable for simple publisher implementations.

Both the lambda and member function patterns follow common ROS 2 best practices.  
The only discouraged approach shown here is the `not_composable.cpp` example.

### not_composable.cpp
Creates a publisher without subclassing `rclcpp::Node`.

While this pattern works, it does not support node composition and is generally discouraged in modern ROS 2 applications.

### member_function_with_wait_for_all_acked.cpp
Demonstrates how to wait until published messages are acknowledged before proceeding.
Useful when reliable communication is required.

### member_function_with_unique_network_flow_endpoints.cpp
Shows advanced publisher configuration for unique network flow endpoints.
Useful in complex distributed networking scenarios.

## Build Instructions

From the root of your ROS 2 workspace:

```bash
colcon build --packages-select examples_rclcpp_minimal_publisher
source install/setup.bash
```
Each example corresponds to a different executable built from the source files listed above. The executable name matches the corresponding `
.cpp` filename

## Run Example

```bash
ros2 run examples_rclcpp_minimal_publisher member_function
```

---

## 中文翻译

# 最小发布者示例

本包提供了几个最小化示例，演示如何使用 `rclcpp` 在 ROS 2 中实现发布者节点。

这些示例旨在为 ROS 2 新开发者提供学习参考，展示了发布消息的不同设计模式。

### member_function.cpp
继承 `rclcpp::Node` 并使用成员函数作为定时器回调。

这种模式在 ROS 2 中常用，当节点以类的形式构建时支持节点组合（composition）。

### lambda.cpp
使用 C++ lambda 函数作为定时器回调。

这种方式简洁，适合简单的发布者实现。

lambda 和成员函数模式都遵循常见的 ROS 2 最佳实践。
这里唯一不推荐的方式是 `not_composable.cpp` 示例。

### not_composable.cpp
不继承 `rclcpp::Node` 即创建发布者。

虽然这种模式可以工作，但不支持节点组合，在现代 ROS 2 应用中通常不推荐使用。

### member_function_with_wait_for_all_acked.cpp
演示如何在继续之前等待已发布的消息被确认。
在需要可靠通信时非常有用。

### member_function_with_unique_network_flow_endpoints.cpp
展示针对唯一网络流端点的高级发布者配置。
在复杂的分布式网络场景中有用。

## 构建说明

在 ROS 2 工作空间的根目录下：

```bash
colcon build --packages-select examples_rclcpp_minimal_publisher
source install/setup.bash
```
每个示例对应一个从上述源文件构建的不同可执行文件。可执行文件名与对应的 `.cpp` 文件名一致。

## 运行示例

```bash
ros2 run examples_rclcpp_minimal_publisher member_function
```
