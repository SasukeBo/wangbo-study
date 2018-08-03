# Supervisor and Application

目前为止，registry可以监控很多buckets。
一旦某个bucket出错，有Supervisor来帮我们重启进程，完全不必担心这种问题的出现。

## Our first supervisor

Supervisor很像GenServer，KV.Supervisor：

```elixir
defmodule KV.Supervisor do
  use Supervisor

  def start_link(opts) do
    Supervisor.start_link(__MODULE__, :ok, opts)
  end

  def init(:ok) do
    children = [
      {KV.Registry}
    ]

    Supervisor.init(children, strategy: :one_for_one)
  end
end
```

目前这个supervisor只有一个子进程KV.Registry。在定义完子进程列表后，调用init来启动这些子进程。
strategy是进程重启策略，one_for_one选项表示一个进程停止重启一个进程。

supervisor启动后，会遍历children，调用它们的child_spec/1方法，获得每个子进程的启动配置。

这个方法是自动生成的，凡是use了Agent、GenServer或Supervisor的模块都会获得这个方法。
也意味着这些模块都可被添加到supervisor树中。

```sh
iex> KV.Registry.child_spec([])
%{
  id: KV.Registry,
  restart: :permanent,
  shutdown: 5000,
  start: {KV.registry, :start_link, [[]]},
  type: :worker
}
```

## Naming processes

虽然我们的应用会有很多的bucket，但是registry只有一个。可以给registry命名，访问它时只需提供名字。

另外需要注意的是，bucket是异步启动的，取决于用户的输入，所以不要用atom来给bucket命名，会造成内存浪费。

```elixir
  def init(:ok) do
    children = [
      {KV.Registry, name: KV.Registry}
    ]

    Supervisor.init(children, strategy: :one_for_one)
  end
```

`KV.Registry`是一个atom，不信的话可以去iex试一试`is_atom(KV.Registry)`。
用它来给KV.Registry进程命名，及时发生崩溃，也会被supervisor重启并且还是使用这个atom，
而不会创建多余的atom造成内存无法回收。

## Understanding applications

每次修改文件重编译都会有`Generated kv app`的信息显示在屏幕。

可以找到这个生成的.app文件：_build/dev/lib/kv/ebin/kv.app。

have a look:

```
{application,kv,
           [{applications,[kernel,stdlib,elixir,logger]},
            {description,"kv"},
            {modules,['Elixir.KV','Elixir.KV.Bucket','Elixir.KV.Registry',
                      'Elixir.KV.Supervisor']},
            {registered,[]},
            {vsn,"0.1.0"},
            {extra_applications,[logger]}]}.
```

这段Erlang代码定义了app。

### Strating applications

定义一个配置应用的.app文件，就可以启动和停止整个应用。
而Mix已经自动帮我们做了这些工作。

来看看Mix是如何启动应用的，先在iex中尝试一下：

```sh
iex> Application.start(:kv)
{:error, {:already_started, :kv}}
```

显然当你执行`iex -S mix`时已经启动的真个application。
在项目中的mix.exs文件中，所有定义的application都会被Mix启动。

`iex -S mix run --no-start`指令可以让Mix不启动application：

```sh
iex> Application.start(:kv)
:ok
```

如果是一个有很多依赖项（dependencies)的项目，需要对项目树深度优先遍历启动application。
不然当你启动顶层application是总会反馈给你`{:error, {:not_started, :some_deps_app}}`

还可以通过`Application.stop/1`手动停止app。

### The application callback

我们可以定义一个Application回调函数，应用被启动时就会调用这个回调函数，
这个函数的返回值是`{:ok, pid}`，其中pid是顶层的supervisor进程ID。

配置这个回调函数只需要两步：

在mix.exs文件中，修改application方法：

```elixir
  def application do
    [
      extra_applications: [:logger],
      mod: {KV.Application, []}
    ]
  end
```

`:mod`选项配置为回调函数所在的模块，后面的list是传递给application start，
而这个回调函数所在的模块可以是任意实现了Application行为的模块

一般mix new [项目名] --sup会自动生成lib/application.ex文件，而这个文件就是我们需要的。

```elixir
defmodule KV.Application do
  use Application

  def start(_type, _args) do
    KV.Supervisor.start_link(name: KV.Supervisor)
  end
end
```

`start/2`就是回调函数，还有一些其他的回调函数。例如`stop/1`。

现在执行`iex -S mix`会直接启动application，在iex中执行：

```sh
iex> KV.Registry.create(KV.Registry, "shopping")
:ok
iex> KV.Registry.lookup(KV.Registry, "shopping")
{:ok, #PID<...>}
```

毫无疑问，KV.Registry进程已经启动，且被注册为模块名。

### Projects or applications?

Mix区别对待projects和applications。

举个例子，Mix就是一个project，它知道如何编译、测试、启动app。
而applications是运行环境中完整的可启动可停止的实体。

更多关于[Application module](https://hexdocs.pm/elixir/Application.html)
