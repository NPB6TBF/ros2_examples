# examples_rclcpp_cbg_executor

The *examples_rclcpp_cbg_executor* package provides a demo and test bench for the *Callback-group-level Executor* concept. This concept was developed in 2018 and has been integrated in ROS 2 mainline in 2020, i.e., is available from ROS 2 Galactic on. It does not add a new Executor but leverages callback groups for refining the Executor API to callback-group-level granularity.

This allows a single node to have callbacks with different real-time requirements assigned to different Executor instances – within one process. Thus, an Executor instance can be dedicated to one or few specific callback groups and the Executor’s thread (or threads) can be prioritized according to the real-time requirements of these groups. For example, all critical callbacks may be handled by an Executor instance based on an thread running at the highest scheduler priority.

## Introduction to demo

The demo comprises a *Ping Node* and a *Pong Node* which exchange messages on two communication paths simultaneously. There is a high priority path formed by the topics *high_ping* and *high_pong* and a low priority path formed by *low_ping* and *low_pong*, respectively.

![](doc/ping_pong_diagram.png)

The Ping Node sends ping messages on both paths simultaneously at a configurable rate. The Pong Node takes these ping messages and replies each of them. Before sending a reply, it burns a configurable number of CPU cycles (thereby varying the processor load) to simulate some message processing.

All callbacks of the Ping Node (i.e., for the timer for sending ping messages and for the two subscription on high_pong and low_pong) are handled in one callback group and thus Executor instance. However, the two callbacks of the Pong Node that process the incoming ping messages and answer with a pong message are assigned to two different callback groups. In the main function, these two groups are distributed to two Executor instances and threads. Both threads are pinned to the same CPU (No. 0) and thus share its processing power, but with different scheduler priorities following the names *high* and *low*.

## Running the demo

The Ping Node and Pong Node may be either started in one process or in two processes. Please note that on Linux the demo requires sudo privileges to be able to change the thread priorities using `pthread_setschedparam(..)`.

Running the two nodes in one process:

```bash
sudo bash
source /opt/ros/[ROS_DISTRO]/setup.bash
ros2 run examples_rclcpp_cbg_executor ping_pong
```

Example of a typical output - note the zero pongs received on the low prio path:

```
[INFO] [..] [pong_node]: Running experiment from now on for 10 seconds ...
[INFO] [..] [ping_node]: Both paths: Sent out 953 of configured 1000 pings, i.e. 95%.
[INFO] [..] [ping_node]: High prio path: Received 951 pongs, i.e. for 99% of the pings.
[INFO] [..] [ping_node]: High prio path: Average RTT is 14.0ms.
[INFO] [..] [ping_node]: High prio path: Jitter of RTT is 7.460ms.
[INFO] [..] [ping_node]: Low prio path: Received 0 pongs, i.e. for 0% of the pings.
[INFO] [..] [pong_node]: High priority executor thread ran for 9542ms.
[INFO] [..] [pong_node]: Low priority executor thread ran for 0ms.
```

Note: On Linux, the two Executor threads, which are both scheduled under `SCHED_FIFO`, can consume only 95% of the CPU time due to [RT throttling](https://wiki.linuxfoundation.org/realtime/documentation/technical_basics/sched_rt_throttling).

Running the two nodes in separate processes:

```bash
sudo bash
source /opt/ros/[ROS_DISTRO]/setup.bash
ros2 run examples_rclcpp_cbg_executor ping
```

```bash
sudo bash
source /opt/ros/[ROS_DISTRO]/setup.bash
ros2 run examples_rclcpp_cbg_executor pong
```

The two processes should be started simultaneously as the experiment runtime is just 10 seconds.

## Parameters

There are three parameters to configure the experiment:

* `ping_period` - period (double value in seconds) for sending out pings on the topics high_ping and low_ping simultaneously in the Ping Node.
* `high_busyloop` - duration (double value in seconds) for burning CPU cycles on receiving a message from high_ping in the Pong Node.
* `low_busyloop` - duration (double value in seconds) for burning CPU cycles on receiving a message from low_ping in the Pong Node.

The default values are 0.01 seconds for all three parameters.

Example for changing the values on the command line:

```bash
ros2 run examples_rclcpp_cbg_executor ping_pong --ros-args -p ping_period:=0.033 -p high_busyloop:=0.025
```

With these values, about (0.033s - 0.025s) / 0.010s = 80% of the ping messages on the low prio path should be processed and answered by a pong message:

```
...
[INFO] [..] [ping_node]: Both paths: Sent out 294 of configured 303 pings, i.e. 97%.
[INFO] [..] [ping_node]: High prio path: Received 293 pongs, i.e. for 99% of the pings.
[INFO] [..] [ping_node]: High prio path: Average RTT is 26.2ms.
[INFO] [..] [ping_node]: High prio path: Jitter of RTT is 7.654ms.
[INFO] [..] [ping_node]: Low prio path: Received 216 pongs, i.e. for 73% of the pings.
[INFO] [..] [ping_node]: Low prio path: Average RTT is 202.5ms.
[INFO] [..] [ping_node]: Low prio path: Jitter of RTT is 36.301ms.
...
```

## Implementation details

The Ping Node and the Pong Node are implemented in two classes `PingNode` (see [ping_node.hpp](include/examples_rclcpp_cbg_executor/ping_node.hpp)) and `PongNode` (see [pong_node.hpp](include/examples_rclcpp_cbg_executor/pong_node.hpp)), respectively. In addition to the mentioned timer and subscriptions, the PingNode class provides a function `print_statistics()` to print statistics on the number of sent and received messages on each path and the average round trip times. To burn the specified number of CPU cycles, the PongNode class contains a function `burn_cpu_cycles(duration)` to simulate a given processing time before replying with a pong.

The Ping and Pong nodes, the two executors, etc. are composed and configured in the `main(..)` function of [main.cpp](src/main.cpp). This function also starts and ends the experiment for a duration of 10 seconds and prints out the throughput and round trip time (RTT) statistics.

The demo also runs on Windows, where the two threads are prioritized as *above normal* and *below normal*, respectively, which does not require elevated privileges. When running the demo on Linux without sudo privileges, a warning is shown but the execution is not stopped.

## Known issues

On macOS the core pinning failed silently in our experiments. Please see the function `configure_native_thread(..)` in [utilities.hpp](src/examples_rclcpp_cbg_executor/utilities.hpp) for details.

---

## 中文翻译

# examples_rclcpp_cbg_executor

*examples_rclcpp_cbg_executor* 包提供了*回调组级别执行器（Callback-group-level Executor）*概念的演示和测试平台。该概念于 2018 年开发，并于 2020 年集成到 ROS 2 主线中，即从 ROS 2 Galactic 开始可用。它没有添加新的执行器，而是利用回调组将执行器 API 细化到回调组级别的粒度。

这允许单个节点将具有不同实时要求的回调分配到不同的执行器实例——在一个进程中。因此，执行器实例可以专用于一个或几个特定的回调组，执行器的线程可以根据这些组的实时要求进行优先级排序。例如，所有关键回调可以由基于以最高调度优先级运行的线程的执行器实例处理。

## 演示简介

演示包括一个 *Ping 节点* 和一个 *Pong 节点*，它们在两条通信路径上同时交换消息。有一条由话题 *high_ping* 和 *high_pong* 组成的高优先级路径，以及一条由 *low_ping* 和 *low_pong* 组成的低优先级路径。

Ping 节点以可配置的速率同时在两条路径上发送 ping 消息。Pong 节点接收这些 ping 消息并逐一回复。在发送回复之前，它会消耗可配置数量的 CPU 周期（从而改变处理器负载）来模拟一些消息处理。

Ping 节点的所有回调（即用于发送 ping 消息的定时器和 high_pong、low_pong 的两个订阅）在一个回调组中处理，因此由一个执行器实例管理。然而，Pong 节点中处理传入 ping 消息并回复 pong 消息的两个回调被分配到两个不同的回调组。在主函数中，这两个组被分配到两个执行器实例和线程。两个线程被固定到同一个 CPU（编号 0），因此共享其处理能力，但具有不同的调度优先级，分别命名为 *high* 和 *low*。

## 运行演示

Ping 节点和 Pong 节点可以在一个进程中启动，也可以在两个进程中启动。请注意，在 Linux 上，演示需要 sudo 权限才能使用 `pthread_setschedparam(..)` 更改线程优先级。

在一个进程中运行两个节点：

```bash
sudo bash
source /opt/ros/[ROS_DISTRO]/setup.bash
ros2 run examples_rclcpp_cbg_executor ping_pong
```

典型输出示例——注意低优先级路径收到的 pong 为零：

```
[INFO] [..] [pong_node]: Running experiment from now on for 10 seconds ...
[INFO] [..] [ping_node]: Both paths: Sent out 953 of configured 1000 pings, i.e. 95%.
[INFO] [..] [ping_node]: High prio path: Received 951 pongs, i.e. for 99% of the pings.
[INFO] [..] [ping_node]: High prio path: Average RTT is 14.0ms.
[INFO] [..] [ping_node]: High prio path: Jitter of RTT is 7.460ms.
[INFO] [..] [ping_node]: Low prio path: Received 0 pongs, i.e. for 0% of the pings.
[INFO] [..] [pong_node]: High priority executor thread ran for 9542ms.
[INFO] [..] [pong_node]: Low priority executor thread ran for 0ms.
```

注意：在 Linux 上，两个执行器线程都在 `SCHED_FIFO` 调度策略下运行，由于 [RT 限流](https://wiki.linuxfoundation.org/realtime/documentation/technical_basics/sched_rt_throttling)，只能消耗 95% 的 CPU 时间。

在两个独立进程中运行两个节点：

```bash
sudo bash
source /opt/ros/[ROS_DISTRO]/setup.bash
ros2 run examples_rclcpp_cbg_executor ping
```

```bash
sudo bash
source /opt/ros/[ROS_DISTRO]/setup.bash
ros2 run examples_rclcpp_cbg_executor pong
```

两个进程应同时启动，因为实验运行时间仅为 10 秒。

## 参数

有三个参数可配置实验：

* `ping_period` - 在 Ping 节点中同时在 high_ping 和 low_ping 话题上发送 ping 的周期（双精度浮点值，单位为秒）。
* `high_busyloop` - 在 Pong 节点中接收到 high_ping 消息后消耗 CPU 周期的持续时间（双精度浮点值，单位为秒）。
* `low_busyloop` - 在 Pong 节点中接收到 low_ping 消息后消耗 CPU 周期的持续时间（双精度浮点值，单位为秒）。

三个参数的默认值均为 0.01 秒。

在命令行上修改参数值的示例：

```bash
ros2 run examples_rclcpp_cbg_executor ping_pong --ros-args -p ping_period:=0.033 -p high_busyloop:=0.025
```

使用这些值，大约 (0.033s - 0.025s) / 0.010s = 80% 的低优先级路径上的 ping 消息应被处理并回复 pong 消息。

## 实现细节

Ping 节点和 Pong 节点分别在 `PingNode`（见 [ping_node.hpp](include/examples_rclcpp_cbg_executor/ping_node.hpp)）和 `PongNode`（见 [pong_node.hpp](include/examples_rclcpp_cbg_executor/pong_node.hpp)）两个类中实现。除了上述的定时器和订阅外，PingNode 类还提供了 `print_statistics()` 函数来打印每条路径上发送和接收消息数量以及平均往返时间的统计信息。为了消耗指定数量的 CPU 周期，PongNode 类包含一个 `burn_cpu_cycles(duration)` 函数，用于在回复 pong 之前模拟给定的处理时间。

Ping 和 Pong 节点、两个执行器等在 [main.cpp](src/main.cpp) 的 `main(..)` 函数中组合和配置。该函数还启动和结束持续 10 秒的实验，并打印吞吐量和往返时间（RTT）统计信息。

该演示也可在 Windows 上运行，其中两个线程分别设置为*高于正常*和*低于正常*优先级，不需要提升权限。在 Linux 上不使用 sudo 权限运行演示时，会显示警告但不会停止执行。

## 已知问题

在 macOS 上，在我们的实验中核心绑定会静默失败。详情请参见 [utilities.hpp](src/examples_rclcpp_cbg_executor/utilities.hpp) 中的 `configure_native_thread(..)` 函数。