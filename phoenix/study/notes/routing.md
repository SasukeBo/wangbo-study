# Routing

路由是Phoenix应用的中心，将Phoenix比作车轮，那路由就是轮毂。它们匹配Http请求，
转发给控制其中对应的action，连接实时通道。

Phoenix项目初始化的router.ex内容大概如下：

```elixir
defmodule HelloWeb.Router do
  use HelloWeb, :router

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_flash
    plug :protect_from_forgery
    plug :put_secure_browser_headers
  end

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/", HelloWeb do
    pipe_through :browser # Use the default browser stack

    get "/", PageController, :index
  end

  # Other scopes may use custom stacks.
  # scope "/api", HelloWeb do
  #   pipe_through :api
  # end
end
```

`user HelloWeb, :router`使得Phoenix的所有router方法在这里可用。
`get`是一个macro（宏），展开后是`match/5`方法的分句。

大概像这样`def match(:get, "/", PageController, :index, [])`

路由中第一个match被匹配中后就不会再去匹配别的match。

## Examining Routes

`mix phx.routes`

```sh
$ mix phx.routes
page_path GET / HelloWeb.PageController :index
```
其中page_path在Phoenix中被称为path helper，和rails中的路由方法是一样的道理。

## Resources

resources宏展开后会有八个match方法的分句。

```elixir
scope "/", HelloWeb do
  pipe_through :browser # Use the default browser stack

  get "/", PageController, :index
  resources "/users", UserController
end
```

可以通过`:only`和`:except`选项来选择部分路由。

## Forward

`Phoenix.Router.forward/4`宏可以用来发送从特定的path获取的所有请求到特定的plug。
设想一个情景，我们的系统有个专门处理后台工作的模块，我们可以使用forward来定义这些管理员路由。

```elixir
forward "/jobs", BackgroundJob.Plug
```

这样所有以`/jobs`为前缀的路由都会被送达`BackgroundJob.Plug`模块处理。

我们还可以在pipeline中使用`forward/4`宏，假如我们要在用户访问网站控制台页面前确保
这个用户是已登录状态而且是管理员身份，就可以这样来写路由：

```elixir
scope "/" do
  pipe_thorugh [:authenticate_user, :ensure_admin]
  forward "/jobs", BackgroundJob.plug
end
```

被传递给`init/1`方法的opts可以作为forward的第三个参数。例如：假如后台页面允许你设置展示
哪一个应用，就可以这样传递应用名：

```elixir
forward "/jobs", BackgroundJob.Plug, name: "Hello Phoenix"
```

下面放一个BackgroundJob.Plug实例

```elixir
defmodule BackgroundJob.Plug do
  def init(opts), do: opts
  def call(conn, opts) do
    conn
    |> Plug.Conn.assign(:name, Keyword.get(opts, :name, "Background Job"))
    |> BackgroundJob.Router.call(opts)
  end
end

defmodule BackgroundJob.Router do
  use Plug.Router

  plug :match
  plug :dispatch

  get "/", do: send_resp(conn, 200, "Welcome to #{conn.assigns.name}")
  get "/active", do: send_resp(conn, 200, "5 Active Jobs")
  get "/pending", do: send_resp(conn, 200, "3 Pending Jobs")
  match _, do: send_resp(conn, 404, "Not found")
end
```
