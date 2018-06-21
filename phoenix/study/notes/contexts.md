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

```elixir
# user.ex
- alias Hello.Accounts.User
+ alias Hello.Accounts.{User, Credential}


  schema "users" do
    field :name, :string
    field :username, :string
+   has_one :credential, Credential

    timestamps()
  end
```

我们使用has_one宏来定义User和Credential之间的父子关系。
然后还需要修改credential.ex文件：

```elixir
# credential.ex
- alias Hello.Accounts.Credential
+ alias Hello.Accounts.{Credential, User}


  schema "credentials" do
    field :email, :string
-   field :user_id, :id
+   belongs_to :user, User

    timestamps()
  end
```

最后我们去修改accounts.ex文件

```elixir
  def list_users do
    User
    |> Repo.all()
    |> Repo.preload(:credential)
  end

  def get_user!(id) do
    User
    |> Repo.get!(id)
    |> Repo.preload(:credential)
  end
```

添加`preload`使得只要访问user就会预加载credential，不必担心在没有请求credential
数据时无法得到用户相关的其他数据。

接下来我们在增加用户的表单中去添加credential的input。

templates/user/form.html.eex

```html
+ <div class="form-group">
+   <%= inputs_for f, :credential, fn cf -> %>
+     <%= label cf, :email, class: "control-label" %>
+     <%= text_input cf, :email, class: "form-control" %>
+     <%= error_tag cf, :email %>
+   <% end %>
+ </div>
```

`inputs_for`将input绑定到父表单。
然后我们再去show页面添加显示用户邮箱的代码

```html
+ <li>
+   <strong>Email:</strong>
+   <%= @user.credential.email %>
+ </li>
</ul>
```

我们还需要修改accounts.ex的部分代码：

```elixir
- alias Hello.Accounts.User
+ alias Hello.Accounts.{User, Credential}
  ...

  def update_user(%User{} = user, attrs) do
    user
    |> User.changeset(attrs)
+   |> Ecto.Changeset.cast_assoc(:credential, with: &Credential.changeset/2)
    |> Repo.update()
  end

  def create_user(attrs \\ %{}) do
    %User{}
    |> User.changeset(attrs)
+   |> Ecto.Changeset.cast_assoc(:credential, with: &Credential.changeset/2)
    |> Repo.insert()
  end
  ...

- alias Hello.Accounts.Credential
```
需要添加cast_assoc，大概是关联获取表单输入的数据，如果没有这行，从表单接受的数据将
永远忽略email。with选项则是指明数据验证需要使用`Credential.chengeset`方法。

## Adding Account functions

试着写写用户登录验证的功能。

修改accounts.ex文件

```elixir
def authenticate_by_email_password(email, _password) do
  query =
    from u in User,
      inner_join: c in assoc(u, :credential),
      where: c.email == ^email

  case Repo.one(query) do
    %User{} = user -> {:ok, user}
    nil -> {:error, :unauthorized}
  end
end
```

添加登录页面之前先添加会话控制器`session_controller.ex`
