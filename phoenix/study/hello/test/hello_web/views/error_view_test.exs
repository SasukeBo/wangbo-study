defmodule HelloWeb.ErrorViewTest do
  use HelloWeb.ConnCase, async: true

  @moduletag [error_view_case: true] # 标记测试模块，测试时可以筛选
  # Bring render/3 and render_to_string/3 for testing custom views
  import Phoenix.View

  @tag individual_test: "yup" # 标记单个测试，用于测试时指定单个测试
  test "renders 404.html" do
    assert render_to_string(HelloWeb.ErrorView, "404.html", []) =~
           "Sorry, the page you are looking for does not exist."
 end

  @tag individual_test: "nope"
  test "renders 500.html" do
    assert render_to_string(HelloWeb.ErrorView, "500.html", []) ==
           "Server internal error"
  end
end
