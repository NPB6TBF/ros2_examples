# Minimal subscriber cookbook recipes

This package contains a few different strategies for creating nodes which receive messages:
 * `lambda.cpp` uses a C++11 lambda function
 * `member_function.cpp` uses a C++ member function callback
 * `not_composable.cpp` uses a global function callback without a Node subclass
 * `wait_set_subscriber.cpp` uses a `rclcpp::WaitSet` to wait and poll for data
 * `static_wait_set_subscriber.cpp` uses a `rclcpp::StaticWaitSet` to wait and poll for data
 * `time_triggered_wait_set_subscriber.cpp` uses a `rclcpp::Waitset` and a timer to poll for data
   periodically
 * `content_filtering.cpp` uses the content filtering feature for Subscriptions

Note that `not_composable.cpp` instantiates a `rclcpp::Node` _without_ subclassing it.
This was the typical usage model in ROS 1, but this style of coding is not compatible with composing multiple nodes into a single process.
Thus, it is no longer the recommended style for ROS 2.

All of these nodes do the same thing: they create a node called `minimal_subscriber` and subscribe to a topic named `topic` which is of datatype `std_msgs/String`.
When a message arrives on that topic, the node prints it to the screen.
We provide multiple examples of different coding styles which achieve this behavior in order to demonstrate that there are many ways to do this in ROS 2.

The following examples `wait_set_subscriber.cpp`, `static_wait_set_subscriber.cpp` and `time_triggered_wait_set_subscriber.cpp` show how to use a subscription in a node using a `rclcpp` wait-set.
This is not a common use case in ROS 2 so this is not the recommended strategy to  use by-default.
This strategy makes sense in some specific situations, for example when the developer needs to have more control over callback order execution, to create custom triggering conditions or to use the timeouts provided by the  wait-sets.   

The example `content_filtering.cpp` shows how to use the content filtering feature for Subscriptions.

---

## 中文翻译

# 最小订阅者示例

本包包含几种创建接收消息的节点的不同策略：
 * `lambda.cpp` 使用 C++11 lambda 函数
 * `member_function.cpp` 使用 C++ 成员函数回调
 * `not_composable.cpp` 使用全局函数回调，不继承 Node 子类
 * `wait_set_subscriber.cpp` 使用 `rclcpp::WaitSet` 来等待和轮询数据
 * `static_wait_set_subscriber.cpp` 使用 `rclcpp::StaticWaitSet` 来等待和轮询数据
 * `time_triggered_wait_set_subscriber.cpp` 使用 `rclcpp::Waitset` 和定时器来定期轮询数据
 * `content_filtering.cpp` 使用订阅的内容过滤功能

注意 `not_composable.cpp` 实例化了 `rclcpp::Node` 但_没有_继承它。
这是 ROS 1 中的典型用法模式，但这种编码方式不兼容将多个节点组合到单个进程中。
因此，这不再是 ROS 2 推荐的风格。

所有这些节点做同样的事情：它们创建一个名为 `minimal_subscriber` 的节点，订阅名为 `topic` 的话题，数据类型为 `std_msgs/String`。
当消息到达该话题时，节点将其打印到屏幕。
我们提供了实现此行为的多种不同编码风格的示例，以展示在 ROS 2 中有多种方式可以做到这一点。

以下示例 `wait_set_subscriber.cpp`、`static_wait_set_subscriber.cpp` 和 `time_triggered_wait_set_subscriber.cpp` 展示了如何使用 `rclcpp` 等待集在节点中使用订阅。
这在 ROS 2 中不是常见用例，因此默认情况下不推荐使用此策略。
此策略在某些特定情况下是有意义的，例如当开发者需要更多控制回调执行顺序、创建自定义触发条件或使用等待集提供的超时机制时。

`content_filtering.cpp` 示例展示了如何使用订阅的内容过滤功能。
