defmodule HelloWeb.HelloController do
  use HelloWeb, :controller

  plug :assign_welcome_message, "Hi!" when action in [:show]

  def index(conn, params // %{"message" => "Hi!", "name" => "Sasuke"}) do
    # render conn, "index.html"
    conn
    # |> assign(:message, "Welcome Back!")
    |> assign(:message, params["message"])
    |> assign(:name, params["name"]) # 传递多个参数可以使用管道的形式将assign/3串联起来
    |> render("index.html")
    # |> put_resp_content_type("text/plain")
    # |> send_resp(201, "")
  end

  def show(conn, %{"messenger" => messenger}) do
    render conn, :show, messenger: messenger
  end

  defp assign_welcome_message(conn, msg) do
    assign(conn, :message, msg)
  end
end
