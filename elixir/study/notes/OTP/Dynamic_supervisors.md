# Dynamic supervisors

到这里我们已经成功定义了supervisor，在应用的生命周期内自动化的启动停止进程树。

前面提到，Registry和Bucket之间既是monitor也是link关系，而link是双向的，
任意一个bucket的崩溃会造成registry崩溃。

庆幸的是supervisor会重新启动registry，但毕竟是重启了registry，不能保证它还保留原有的状态。

例如：

```sh
iex> KV.Registry.create(KV.Registry, "shopping")
:ok
iex> {:ok, pid} = KV.Registry.lookup(KV.Registry, "shopping")
{:ok, #PID<0.450.0>}
iex> KV.Registry.create(KV.Registry, "workspace")
:ok
iex> GenServer.stop(pid, :kill)
18:53:37.404 [error] GenServer #PID<0.450.0> terminating
** (stop) :kill
Last message: []
State: %{}
iex> KV.Registry.lookup(KV.Registry, "workspace")
:error
```

这会造成其它没有崩溃的bucket都丢失了。

如何做到在bucket崩溃时registry仍能正常工作。

先写一段测试：

```elixir
  test "removes bucket on crash", %{registry: registry} do
    KV.Registry.create(registry, "shopping")
    {:ok, bucket} = KV.Registry.lookup(registry, "shopping")

    # Stop the bucket eith non-normal reason
    Agent.stop(bucket, :shutdown)
    assert KV.Registry.lookup(registry, "shopping") == :error
  end
```

如果一个进程退出的原因不是:normal，所有link的进程都会受到exit信号，
造成这些进程也会被终止。

接下来解决这个问题。

## The bucket supervisor

定义一个DynamicSupervisor：

```elixir
  def init(:ok) do
    children = [
      {KV.Registry, name: KV.Registry},
      {DynamicSupervisor, name: KV.BucketSupervisor, strategy: :one_for_one}
    ]

    Supervisor.init(children, strategy: :one_for_one)
  end
```

我们不用定义一个模块来调用`use DynamicSupervisor`。
直接在Supervisor树中启动它， `DynamicSupervisor`在初始化时不需要任何子进程。

在iex中试试：

```sh
iex> {:ok, bucket} = DynamicSupervisor.start_child(KV.BucketSupervisor, KV.Bucket)
{:ok, #PID<0.72.0>}
iex> KV.Bucket.put(bucket, "eggs", 3)
:ok
iex> KV.Bucket.get(bucket, "eggs")
3
```

`DynamicSupervisor.start_child/2`需要DynamicSupervisor的名字，
在KV.Supervisor的子进程中，我们已经启动了一个DynamicSupervisor，并且命名为`KV.BucketSupervisor`。
还需要子进程的配置，这里就传递了KV.Bucket模块名（大概会自己调用child_spec方法来获得进程配置。）

最后一步就是修改registry来使用dynamic supervisor：

```elixir
  def handle_cast({:create, name}, {names, refs}) do
    if Map.has_key?(names, name) do
      {:noreply, {names, reffs}}
    else
      {:ok, pid} = DynamicSupervisor.start_child(KV.BucketSupervisor, KV.Bucket)
      ref = Process.monitor(pid)
      refs = Map.put(refs, ref, name)
      names = Map.put(names, name, pid)
      {:noreply, {names, refs}}
    end
  end
```

这样就足够通过测试了，但是这里还有个问题就是资源泄露，
当一个bucket终止， supervisor会启动一个新的bucket，
在当前场景下，重新启动的新的bucket不会被我们利用，因为它没有被存储在registry中。
这就造成了资源浪费。
毕竟，这就是supervisor的工作。

要解决这个问题就要设置restart选项，将bucket的`:restart`设置为`:temporary`，崩溃后不会被重启。

```elixir
defmodule KV.Bucket do
  use Agent, restart: :temporary
```

添加一段测试来保证bucket是temporary：

```elixir
  test "are temporary workers" do
    assert Supervisor.child_spec(KV.Bucket, []).restart == :temporary
  end
```

用动态Supervisor来启动Bucket的好处就在这里，因为supervisor能做的不只是重启子进程，
它还能保证正确的启动和关闭，特别是在supervisor树发生了崩溃时。

## Supervision trees

当我们添加`KV.BucketSupervisor`作为`KV.Supervisor`的子进程时，我们就有了一个supervisor树。

每当添加新的子进程到树中，都需要考虑是否使用了正确的启动策略，以及正确的子进程顺序。

在这个例子中，我们使用:one_for_one策略，并且KV.Registry在KV.BucketSupervisor之前启动。

很明显子进程顺序是不合适的，因为KV.Registry中使用了KV.BucketSupervisor进程，因此KV.BucketSupervisor应该在
KV.Registry之前启动。

另外，启动策略也是不合适的，如果KV.Registry进程死掉，所有关联name和bucket PID的信息会丢失。
因此KV.BucketSupervisor和所有的bucket都应该停止，否则它们会成为“孤儿进程”，没有办法去访问它们。

因此我们需要考虑另一种策略，可选的有`:one_for_all`和`:rest_for_all`。

使用`:rest_for_all`策略会杀死所有在崩溃子进程启动顺序之后的子进程并重启它们，
在这个例子中我们希望KV.BucketSupervisor在KV.Registry奔溃时也停止。
这就需要将KV.BucketSupervisor放置在KV.Registry之后，这又恰好与上面的推论违背。

所以最后的选择只有是`:one_for_all`策略，一个崩溃重启所有！

```elixir
 def init(:ok) do
    children = [
      {DynamicSupervisor, name: KV.BucketSupervisor, strategy: :one_for_one},
      {KV.Registry, name: KV.Registry}
    ]

    Supervisor.init(children, strategy: :one_for_all)
  end
```
