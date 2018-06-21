## Socket Connection

建立一个简单的到服务器的连接，在这个连接上，Channels是多路复用的。
使用Socket类来连接到服务器：

```javascript
let socket = new Socket("/socket", {params: {userToken: "123"}})
socket.connect()
```
