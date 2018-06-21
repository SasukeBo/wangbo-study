defmodule HelloWeb.PageView do
  use HelloWeb, :view
  # def render("index.html", assigns) do # 这里的assigns就是controller中调用render时传入的参数
  #   "rendering with assigns #{inspect Map.keys(assigns)} #{assigns[:message]}"
  # end
  def message do
    "Hello from the view!"
  end

  def render("index.json", %{pages: pages}) do
    %{data: render_many(pages, HelloWeb.PageView, "page.json")}
  end

  def render("show.json", %{page: page}) do
    %{data: render_one(page, HelloWeb.PageView, "page.json")}
  end

  def render("page.json", %{page: page}) do
    %{title: page.title}
  end

  def handler_info(conn) do
    "Request Handled By: #{controller_module conn}.#{action_name conn}"
  end

  def connection_keys(conn) do
    conn
    |> Map.from_struct()
    |> Map.keys()
  end
end
