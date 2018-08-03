# Endpoint

Phoenix应用将Endpoint作为监控进程启动。所有的request的生命周期都在apllication的endpoint中完成。

## Endpoint Contents

Endpoint聚集了通常的功能，作为应用的HTTP请求入口和出口。Endpoint包含对所有请求通用的plugs。

```elixir
use Phoenix.Endpoint, otp_app: :hello
```
`otp_app`is used for the configuration。
这行代码将Phoenix.Endpoint中的很多方法引入了应用的Endpoint，包括在supervision tree中调用的start_link方法。

```elixir
socket "/socket", HelloWeb.UserSocket
```
声明一个socket，"/socket"路由会被HelloWeb.UserSocket处理而不是Router。

```elixir
plug Plug.Static,
  at: "/", from: :hello, gzip: false,
  only: ~w(css fonts image js favicon.ico robots.txt)
```

如果code reloading被启用，当服务器代码发生改变时，socket可以用于通知浏览器重加载页面来同步服务器的变更。这个特性可以再config中配置。

```elixir
if code_reloading? do
  socket "/phoenix/live_reload/socket", Phoenix.LiveReloader.Socket
  plug Phoenix.LiveReloader
  plug Phoenix.CodeReloader
end
```

`plug Plug.Logger`打印日志，默认包括请求的路由，状态码和请求时间。

Plug.Session处理session的cookies和session存储。

```elixir
plug Plug.Session,
  store: :cookie,
  key: "_hello_key",
  signing_salt: "change_me"
```

最后一个plug就是Router了。

默认生成的Endpoint的最后还有一个init方法。
这个方法用于动态配置。

```elixir
def init(_key, config) do
  if config[:load_from_system_env] do
    port = System.get_env("PORT") || raise "expected the PORT environment variable to be set"
    {:ok, Keyword.put(config, :http, [:inet6, port: port])}
  else
    {:ok, config}
  end
end
```

## Using SSl

## Force SSL

## Releasing with Exrm
