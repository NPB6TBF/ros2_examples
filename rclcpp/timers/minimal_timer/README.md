# Minimal timer examples

This package contains a few different strategies for creating short nodes which have timers.
The `timer_lambda` and `timer_member_function` examples create subclasses of `rclcpp::Node` and set up an `rclcpp::timer` to periodically call functions which just print Hello to the console. They do the same thing, just using different C++ language features.

---

## 中文翻译

# 最小定时器示例

本包包含几种创建带有定时器的简单节点的不同策略。
`timer_lambda` 和 `timer_member_function` 示例创建了 `rclcpp::Node` 的子类，并设置 `rclcpp::timer` 来定期调用函数，这些函数只是向控制台打印 Hello。它们做的是同样的事情，只是使用了不同的 C++ 语言特性。
