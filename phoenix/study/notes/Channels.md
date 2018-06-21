## Channels

使用Channels可以轻松为我们的软件增加软实时功能。
发送者广播一条属于某个topic的消息，而订阅了这个topic的接受者可以收到这条消息。
发送者和使用者可以随时角色互换。

通过Channels，发送者和接受者不必要是Elixir程序，它可以是JS客户端、IOS app或者另一个
Phoenix应用，甚至可以是一个手表。

并且Channels发布消息是多对多，而Elixir通信进程只是一对一。

## JS 文档

Phoenix附带了JavaScript客户端，当你生成新的Phoenix项目时就可以使用。

