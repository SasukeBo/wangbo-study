# plug

Phoenix的组成部分中，Endpoints，Routers和Controllers实际上都是Plugs。
Plug分为方法plug和模块plug

## Function Plugs

一个方法接收一个`%Plug.Conn{}`结构体和options，最终还会返回这个结构体，就可以被视为一个plug。

```elixir
def put_headers(conn, key_values) do
  Enum.reduce key_values, conn, fn {k, v}, conn ->
    Plug.Conn.put_resp_header(conn, to_string(k), v)
  end
end
```

在Phoenix中，我们用这种方式组合连接过程中的变化。

```elixir
defmodule HelloWeb.MessageController do
  use HelloWeb, :controller

  plug :put_headers, %{content_encoding: "gzip", cache_control: "max-age=3600"}
  plug :put_layout, "bare.html"

  ...

end
```

对比下面两段代码，看出plug的优点：

```elixir
defmodule HelloWeb.MessageController do
  use HelloWeb, :controller

  def show(conn, params) do
    case authenticate(conn) do
      {:ok, user} ->
        case find_message(params["id"]) do
          nil ->
            conn |> put_flash(:info, "That message wasn't found") |> redirect(to: "/")
          message ->
            case authorize_message(conn, params["id"]) do
              :ok ->
                render conn, :show, page: find_message(params["id"])
              :error ->
                conn |> put_flash(:info, "You can't access that page") |> redirect(to: "/")
            end
        end
      :error ->
        conn |> put_flash(:info, "You must be logged in") |> redirect(to: "/")
    end
  end
end
```

```elixir
defmodule HelloWeb.MessageController do
  use HelloWeb, :controller

  plug :authenticate
  plug :fetch_message
  plug :authorize_message

  def show(conn, params) do
    render conn, :show, page: find_message(params["id"])
  end

  defp authenticate(conn, _) do
    case Authenticator.find_user(conn) do
      {:ok, user} ->
        assign(conn, :user, user)
      :error ->
        conn |> put_flash(:info, "You must be logged in") |> redirect(to: "/") |> halt()
    end
  end

  defp fetch_message(conn, _) do
    case find_message(conn.params["id"]) do
      nil ->
        conn |> put_flash(:info, "That message wasn't found") |> redirect(to: "/") |> halt()
      message ->
        assign(conn, :message, message)
    end
  end

  defp authorize_message(conn, _) do
    if Authorizer.can_access?(conn.assigns[:user], conn.assigns[:message]) do
      conn
    else
      conn |> put_flash(:info, "You can't access that page") |> redirect(to: "/") |> halt()
    end
  end
end
```

由此可见plug的好处在于可复用，过程可组合，结构清晰，可读性高。
接下来我们看看模块plugs。

## Module Plugs

模块Plugs允许我们在模块中处理连接转换（connection transformation），这样的模块需要实现两个方法：

* `init/1` 方法初始化options，最终传递给`call/2`方法。
* `call/2` 方法负责处理连接转换，它其实就是一个function plug。

下面我们看一个例子，模块plug将一组key-value放置到connection assign中，被用于其他的plug中（actions、views）

```elixir
defmodule HelloWeb.Plugs.Locale do
  import Plug.Conn

  @locales ["en", "fr", "de"]

  def init(default), do: default

  def call(%Plug.Conn{params: %{"locale" => loc}} = conn, _default) when loc in @locales do
    assign(conn, :locale, loc)
  end
  def call(conn, default), do: assign(conn, :locale, default)
end

defmodule HelloWeb.Router do
  use HelloWeb, :router

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_flash
    plug :protect_from_forgery
    plug :put_secure_browser_headers
    plug HelloWeb.Plugs.Locale, "en"
  end
  ...

end
```

通过`plug HelloWeb.Plugs.Locale, "en"`将这个module plug加入到browser pipeline。
其中"en"就是传递给`init/1`的default值，如果conn中的params有"locale"键值对，且其
值在@locales中存在，则会被assign到conn的`:locale`，否则第二个`call/2`的default
是打开的，它会接收`init/1`传递给它的default值（本例中是"en"），然后被加入到conn
assigns。

If we ask oueselves, "Could I put this in a plug?" The answer is usually "Yes!".

通常我们想把一个功能放置到plug，都是可以实现的。
