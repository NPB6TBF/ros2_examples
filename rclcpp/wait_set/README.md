# Minimal rclcpp wait-set cookbook recipes

This package contains a few different strategies for creating nodes which use `rclcpp::waitset`
to wait and handle ROS entities, that is, subscribers, timers, clients, services, guard
conditions and waitables.


* `wait_set.cpp`: Simple example showing how to use the default wait-set with a dynamic
  storage policy and a sequential (no thread-safe) synchronization policy.
* `static_wait_set.cpp`: Simple example showing how to use the static wait-set with a static
  storage policy.
* `thread_safe_wait_set.cpp`: Simple example showing how to use the thread-safe wait-set with a
  thread-safe synchronization policy.
* `wait_set_topics_and_timer.cpp`: Simple example using multiple subscriptions,
  publishers, and a timer.
* `wait_set_random_order.cpp`: An example showing user-defined
  data handling and a random publisher. `executor_random_order.cpp` run the same node logic
  using `SingleThreadedExecutor` to compare the data handling order.
* `wait_set_and_executor_composition.cpp`: An example showing how to combine a  
  `SingleThreadedExecutor` and a wait-set.
* `wait_set_topics_with_different_rate.cpp`: An example showing how to use a custom trigger
  condition to handle topics with different topic rates.

---

## 中文翻译

# 最小 rclcpp 等待集（wait-set）示例

本包包含几种使用 `rclcpp::waitset` 来等待和处理 ROS 实体（即订阅者、定时器、客户端、服务、守护条件和可等待对象）的不同策略。

* `wait_set.cpp`：简单示例，展示如何使用默认等待集（动态存储策略和顺序（非线程安全）同步策略）。
* `static_wait_set.cpp`：简单示例，展示如何使用静态等待集（静态存储策略）。
* `thread_safe_wait_set.cpp`：简单示例，展示如何使用线程安全等待集（线程安全同步策略）。
* `wait_set_topics_and_timer.cpp`：使用多个订阅、发布者和定时器的简单示例。
* `wait_set_random_order.cpp`：展示用户自定义数据处理和随机发布者的示例。`executor_random_order.cpp` 使用 `SingleThreadedExecutor` 运行相同的节点逻辑来比较数据处理顺序。
* `wait_set_and_executor_composition.cpp`：展示如何组合 `SingleThreadedExecutor` 和等待集的示例。
* `wait_set_topics_with_different_rate.cpp`：展示如何使用自定义触发条件来处理具有不同话题速率的话题的示例。