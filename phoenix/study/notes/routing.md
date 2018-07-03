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

## Path Helpers

```elixir
# in iex

import HelloWeb.Router.Helpers
alias HelloWeb.Endpoint
user_path(Endpoint, :index)
user_path(Endpoint, :show, 17)
```

paths with query strings

```elixir
iex> user_path(Endpoint, :show, 17, admin: true, active: "No")
"/users/17?admin=true&active=No"
```

如果想获得完整的url就使用user_url方法即可。

## Nested Resources

嵌套resources，假如我们有个resources叫posts，和users之间是多对一关系。

```elixir
resources "/users", UserController do
  resources "/posts", PostController do
end
```

```sh
user_post_path  GET     /users/:user_id/posts           HelloWeb.PostController :index
user_post_path  GET     /users/:user_id/posts/:id/edit  HelloWeb.PostController :edit
user_post_path  GET     /users/:user_id/posts/new       HelloWeb.PostController :new
user_post_path  GET     /users/:user_id/posts/:id       HelloWeb.PostController :show
user_post_path  POST    /users/:user_id/posts           HelloWeb.PostController :create
user_post_path  PATCH   /users/:user_id/posts/:id       HelloWeb.PostController :update
                PUT     /users/:user_id/posts/:id       HelloWeb.PostController :update
user_post_path  DELETE  /users/:user_id/posts/:id       HelloWeb.PostController :delete
```

```elixir
iex> alias HelloWeb.Endpoint
HelloWeb.Endpoint
iex> HelloWeb.Router.Helpers.user_post_path(Endpoint, :show, 42, 17)
"/users/42/posts/17"
```

## Scoped Routes

scope可以将一组路由配置在同一个路由前缀和plug中间件下。

比如项目中有两个resources都叫reviews，一个是面向普通用户，另一个是面向管理员，则需要区别对待。

普通用户的路由：

```
/reviews
/reviews/1234
/reviews/1234/edit
```

管理员的路由：

```
/admin/reviews
/admin/reviews/1234
/admin/reviews/1234/edit
```

```elixir
scope "/admin", as: :admin do # 加上`as: :admin`可以在生成path_helper时产生admin前缀。
  pipe_through :browser

  resources "/reviews", HelloWeb.Admin.ReviewController
end
```

相对应的Controller的命名空间也需要加上Admin。`HelloWeb.Admin.ReviewController`

更好的写法：

```elixir
scope "/admin", HelloWeb.Admin, as: :admin do
  pipe_through :browser

  resources "/reviews", ReveiwController
end
```

当定义多个resources时就不需要全部都写完整的模块名。

scope也可以被嵌套。但是不推荐，会变得很乱。

## Pipelines

将一些plug按顺序堆在一起，并取名，就得到了pipeline。

Phoenix提供了一些内置的pipeline，当然用户也可以自定义pipeline。

新生成的phoenix项目定义了两个pipeline，`:broswer`和`:api`。

### The Endpoint Plugs

Endpoints将所有适用于任何http请求的plugs组织在一起，并且在router之前执行。
默认的Endpoint Plugs做了很多工作。

* Plug.Static
* Plug.Logger
* Phoenix.CodeReloader, 自动重加载代码，热更新。
* Plug.Parsers 解析请求体
* Plug.MethodOverride
* Plug.Head
* Plug.Session
* Plug.Router

### The browser and api pipeline

:browser pipeline为浏览器请求做准备，:api pipeline为api接口准备数据。

:browser 有5个plugs:
* :accepts, ["html"]，定义接收的请求格式。
* :fetch_session，获取session数据，应用到连接中。
* :fetch_flash，检索被所有被设置的flash消息
* :protect_from_forgery、:put_secure_browser_headers防止跨站伪造。


router一般在scope中调用pipeline，如果没有scope，pipeline将会作用于所有的routes。

pipe_through的参数可以是多个pipeline组成的list。

### Creating New Pipelines

Phoenix允许在router中的任何位置自定义pipeline

```elixir
pipeline :review_checks do
  plug :ensure_authenticated_user
  plug :ensure_user_owns_review
end
```

## Channel Routes

Channels Phoenix框架的实时组件。处理数据输入，通过某个话题的socket广播数据。
Channel routes需要依靠socket和topic来正确匹配channel。

我们将socket handlers嵌入Endpoint，socket handlers负责处理权限验证和channel routes。

```elixir
defmodule HelloWeb.Endpoint do
  use Phoenix.Endpoint

  socket "/socket", HelloWeb.UserSocket
  ...

end
```

在user_socket.ex中，我们使用channel/3宏定义channel routes。routes会去匹配topic
模式匹配串，然后处理事件。

```elixir
defmodule HelloWeb.UserSocket do
  use Phoenix.Socket

  channel "rooms.*", HelloWeb.RoomChannel
  ...

end
```


