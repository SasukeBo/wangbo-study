defmodule KV.Registry do
  use GenServer

  ## Client API

  @doc """
  Starts the registry.
  """
  def start_link(opts) do
    GenServer.start_link(__MODULE__, :ok, opts)
  end

  @doc """
  Looks up the bucket pid for `name` stored in `server`.

  Returns `{:ok, pid}` if the bucket exists, `error` otherwise.
  """
  def lookup(server, name) do
    GenServer.call(server, {:lookup, name})
  end

  @doc """
  Ensures there is a bucket associated with the given `name` in `server`.
  """
  def create(server, name) do
    GenServer.cast(server, {:create, name})
  end

  ## Server Callbacks

  def init(:ok) do
    names = %{}
    refs = %{}
    {:ok, {names, refs}}
  end

  def handle_call({:lookup, name}, _from, {names, _} = state) do
    # handle_call 需要回复信息，而tuple的第二个元素就是回复信息，
    # 用于返回给client。第三个元素用来更新服务器状态（states）
    {:reply, Map.fetch(names, name), state}
  end

  def handle_cast({:create, name}, {names, refs}) do
    # handle_cast 不需要返回回复信息，所以tuple的第二个元素
    # 是用来更新服务端状态（states）的
    if Map.has_key?(names, name) do
      {:noreply, {names, refs}}
    else
      # {:ok, pid} = KV.Bucket.start_link([])
      {:ok, pid} = DynamicSupervisor.start_child(KV.BucketSupervisor, KV.Bucket)
      ref = Process.monitor(pid)
      refs = Map.put(refs, ref, name)
      names = Map.put(names, name, pid)
      {:noreply, {names, refs}}
    end
  end

  @doc """
  这个回调函数会处理所有发送给Registry进程的信息，例如:

  ## Example

      iex> {:ok, pid} = KV.Registry.start_link([])
      iex> send(pid, {:DOWN, "123", :process, "", ""})
      "123"

  如果在里面打印ref，会发现就是"123"
  """
  def handle_info({:DOWN, ref, :process, _pid, _reason}, {names, refs}) do
    IO.inspect ref
    {name, refs} = Map.pop(refs, ref)
    names = Map.delete(names, name)
    {:noreply, {names, refs}}
  end

  def handle_info(_msg, state) do
    {:noreply, state}
  end
end
