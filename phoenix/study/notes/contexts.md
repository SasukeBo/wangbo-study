## In-context Relationships

在使用`mix phx.gen.html` 生成user相关的资源，用于处理用户账号的增删改查之后，我们
需要给用户添加凭证相关的模块，同样是在Acount公开接口之下来管理用户凭证(Credential)。

执行`mix phx.gen.context`任务，类似于`phx.gen.html`，不同之处在于前者不会生成web文件。
因为这个模块主要是处理user信息的一部分，我们只需要将Credential融入到这个web框架中即可。

对于`Account`模块，Phoenix则是将Credential相关的API添加到其中。

按照我们的设计，我们需要在用户删除账号时确保对应的Credential也会被移除。所以需要修改
生成的迁移文件：

```elixir
  def change do
    create table(:credentials) do
      add :email, :string
-     add :user_id, references(:users, on_delete: :nothing)
+     add :user_id, references(:users, on_delete: :delete_all),
+                   null: false

      timestamps()
    end

    create unique_index(:credentials, [:email])
    create index(:credentials, [:user_id])
  end
```

我们修改了`:on_delete`选项，设置为`:delete_all`，同时，`null: false`确保credentials
必须在user存在的前提下才能创建。

再添加credentials到web层之前，我们首先需要让context知道如何关联user和credentials。

