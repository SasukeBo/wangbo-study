defmodule HelloWeb.PageController do
  # 控制器类似中间人角色，里面的函数称为action，响应路由HTTP请求，收集必要的数据并处理view层渲染模板或返回JSON数据。
  use HelloWeb, :controller # use触发__using_/1宏，引入一些有用的模块。
  # Action命名必须满足与路由中定义的route相对应。
  def index(conn, params) do # 第一个参数conn是存储着请求信息的结构体。params则是存储了请求中所有的参数。
    # render conn, "index.html"
    # Flash消息。
    conn
    # |> put_layout(false) # 设置不使用布局模板。
    # |> put_layout("admin.html") # 设置不使用布局模板。
    # |> put_flash(:info, "Welcome to Phoenix, from flash info!")
    # |> put_flash(:error, "Let's pretend we have an error.")
    |> render(:index, message: params["message"])
    # |> redirect(to: "/redirect_test")
    # |> redirect(external: "http://elixir-lang.org/")
    # |> redirect(to: redirect_test_path(conn, :redirect_test))
    # |> redirect(external: redirect_test_url(conn, :redirect_test))
  end

  # def index(conn, _params) do
  #   pages = [%{title: "foo"}, %{title: "bar"}]
  #
  #   render conn, "index.json", pages: pages
  # end

  def show(conn, %{"id" => id}) do
    # text conn, "Showing id #{id}"
    # json conn, %{id: id}
    # html conn, """
    #   <html>
    #     <head>
    #       <title>Passing an ID</title>
    #     </head>
    #     <body>
    #       <p>You sent in id #{id}</p>
    #     </body>
    #   </html>
    # """
    # 以上三个函数在渲染操作时都不需要视图或者模板参与。
    render conn, "show.html", id: id
  end

  def show(conn, _params) do
    page = %{title: "foo"}

    render conn, "show.json", page: page
  end

  def test(conn, _params) do
    render conn, "test.html"
  end

  # def redirect_test(conn, _params) do
  #   text conn, "Redirect Succeed!"
  # end
end
