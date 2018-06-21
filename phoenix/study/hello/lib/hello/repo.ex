defmodule Hello.Repo do

  # 导入Ecto.Repo中的通用查询函数。
  # 将opt_app名字设置为项目的名字。
  use Ecto.Repo, otp_app: :hello

  @doc """
  Dynamically loads the repository url from the
  DATABASE_URL environment variable.
  """
  # 通过传入的参数初始化数据库适配器。
  def init(_, opts) do
    {:ok, Keyword.put(opts, :url, System.get_env("DATABASE_URL"))}
  end
end
