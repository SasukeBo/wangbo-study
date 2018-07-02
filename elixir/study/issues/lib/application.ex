defmodule Issues.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  def start(_type, _args) do
    import Supervisor.Spec, warn: false

    IO.puts "application start!"
    children = [
      Plug.Adapters.Cowboy.child_spec(scheme: :http, plug: MyRouter, options: [port: 4001])
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: Issues.Supervisor]

    Supervisor.start_link(children, opts)
  end
end
