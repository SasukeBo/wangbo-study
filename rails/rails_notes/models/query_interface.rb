# 先引入这些模型
class Client < ApplicationRecord
  has_one :address
  has_many :orders
  has_and_belongs_to_many :roles
end

class Address < ApplicationRecord
  belongs_to :client
end

class Order < ApplicationRecord
  belongs_to :client, counter_cache: true
end

class Role < ApplicationRecord
  has_and_belongs_to_many :clients
end

# 1 从数据库中索引对象
# 1.1 检索单个对象

# 可以使用find方法检索指定主键对应的对象，指定主键时可以使用多个选项。
Client.find(10)
# 查询多个对象
Client.find([1, 10]) # 查找主键为1和10的客户

# take方法检索一条记录而不考虑排序。
Client.take
# select * from clients limit 1
# take方法接受参数
Client.take(2)

Client.first # 默认查找按主键排序的第一条记录。可接受参数。

# 对于使用order排序的集合，first方法返回按照指定属性排序的第一条记录。
Client.order(:first_name).first

Client.last # 主键排序最后一条记录。可接受参数。

# find_by方法查找匹配指定条件的第一条记录。
Client.find_by first_name: 'Lifo'

# 1.2 批量检索多个对象
# 我们常常需要遍历大量记录，例如向大量用户发送时事通讯，导出数据等。
# 处理这类问题看起来可能很简单：
User.all.each do |user|
  NewsMailer.weekly(user).deliver_now
end
# 但随着数据表越来越大，这种方法行不通，会消耗大量内存。

# find_each方法
# 批量检索记录，然后逐一把每条记录作为模型传入块。
User.find_each do |user|
  NewsMailer.weekly(user).deliver_now
end

# find_in_batches 方法
# 同样批量检索记录，但是会把一批记录作为模型!数组!传入块。
Invoice.find_in_batches do |invoices|
  export.add_invoices(invoices)
end

# 2 条件查询
# where方法用于指明限制返回记录所使用的条件，相当于SQL语句的WHERE部分。条件可以
# 使用字符串、数组或散列指定。
Client.where("orders_count = '2'") # 纯字符串条件
# 会查找所有orders_count字段的值为2的客户记录。

Client.where("orders_count = ?", params[:orders]) # 数组条件
# Active Record 会把第一个参数作为条件字符串，并用之后的其他参数来替换条件字符
# 串中的问号
# 我们还可以指定多个条件
Client.where("orders_count = ? and locked = ?", params[:orders], false)
# 第一个问号会被替换为params[:orders]的值，第二个问号会被替换为false在SQl中对应
# 的值

# 条件中的占位符
# 和问号占位符(?)类似,我们还可以在条件字符串中使用符号占位符，并通过三列提供符
# 号对应的值：
Client.where("created_at >= :start_date and created_at <= :end_date",
             {start_date: params[:start_date], end_date: params[:end_date]})

# 2.3 散列条件
# 使用散列条件时，散列的键指明需要限制的字段，键对应的值指明如何进行限制。
# 2.3.1 相等性条件
Client.where(locked: true)
# => select * from clients where (clients.locked = 1) 
# 散列表locked的true对应值为1
# 2.3.2 范围条件
Client.where(created_at: (Time.now.midnight - 1.day)..Time.now.midnight)
# => select * from clinets where (
#                 clinets.created_at between '2008-12-21 00:00:00'
#                  and '2008-12-22 00:00:00')

# 2.3.3 子集条件
# 要想用IN表达式来查找记录，可以再散列条件中使用数组：
Client.where(orders_count: [1,3,5])
# => select * from clients where (clients.orders_count IN (1,3,5))

# 2.4 NOT 条件
# 可以用where.not创建NOT SQL查询
Client.where.not(locked: true)
# => select * from clients where (clients.locked ! = 1)

# 3 排序
# 要想按特定顺序从数据库中检索记录，可以使用order方法。
# 例如，如果想按created_at字段升序方式取回记录:
Client.order(:created_at)
Client.order("created_at")
# 还可以指明使用升序降序ASC/DESC
Client.order(created_at: :desc)
Client.order("created_at DESC")
# 或按多个字段排序
Clinet.order(orders_count: :asc, created_at: :desc)
# 或
Client.order(:orders_count, creates_at: :desc)
# 或
Client.order("order_count ASC, created_at DESC")
# 或
Client.order("order_count ASC", "created_at DESC")

# 如果多次调用order方法，后序排序会在第一次排序的基础上进行。
Client.order("order_count ASC").order("created_at DESC")
# => select * from clients order by orders_count ASC, created_at DESC

# 4 选择指定字段
# model.find默认使用select*从结果中选择所有字段
# 可以使用select方法从结果集中选择某些字段。
Client.select("viewable_by, locked")
# 可以使用distinct方法添加唯一性约束
Client.select(:name).distinct
# => select distinct nam from clients
# 唯一性约束在添加之后还可以删除：
query = Client.select(:name).distinct
query.distinct(false)

# 5 限量和偏移量
# limit 和 offset 方法
Client.limit(5)
Client.limit(5).offset(30)

# 6 分组
# 要想在查找方法生成的SQL语句中使用GROUP BY子句，可以使用group方法。
Order.select("date(created_at) as ordered_date, 
             sum(price) as total_price").group("date(created_at)")
# => select date(created_at) as ordered_date, sum(price) as total_price
#    from orders
#    group by date(created_at)

# 6.1 分组项目总数
# 要想得到一次查询中分组项目的总数，可以在调用group方法后调用count方法。
Order.group(:status).count
# => select count(*) as count_all, status as status from "orders"
#         group by status

# 7 having 方法
# SQL语句用HAVING子句指明GROUP BY字段的约束条件。要想在Model.find生成的SQL语句
# 使用HAVING子句，可以使用having方法。例如：
Order.select("date(created_at) as ordered_date, 
             sum(price) as total_price").group("date(created_at)").having(
               "sum(price) > ?", 100
)
# => select date(created_at) as ordered_date, sum(price) as total_price
#   from orders group by date(created_at)
#   having sum(price) > 100

# 8 条件覆盖
# 8.1 unscope 方法
# 可以使用unscope方法删除某些条件。
Article.where('id > 10').limit(20).order('id asc ').unscope(:order)
# => select * from articles where id > 10 limit 20
# 没有使用'unscope'之前的查询:
# => select * from articles where id > 10 order by id asc limit 20
# 还可以使用unscope方法删除where方法中的某些条件。例如：
Article.where(id: 10, trashed:false).unscope(where: :id)
# => select "articles".* from "articles" where trashed = 0
# 在关联中使用unscope方法，会对整个关联造成影响：

Article.order('id asc').merge(Article.unscope(:order))
# => select "articles".* from "articles"

# 8.2 only 方法
# 可以使用only方法覆盖某些条件。例如：
Article.where('id > 10').limit(20).order('id desc').only(:order, :where)
# 只执行order 和where方法

# 8.3 reorder方法
# 可以使用reorder方法覆盖默认作用域中的排序方式。
# 例如：
class Article < ApplicationRecord
  has_many :comments, ->{order('posted_at DESC')}
end
Article.find(10).comments.reorder('name')
# name覆盖了posted_at DESC，覆盖后默认是升序

# 8.4 reverse_order 方法反转排序条件
Client.where("orders_count > 10").order(:name).reverse_order
# => select * from clients where orders_count > 10 order by name DESC
# 如果查询时没有使用order方法，那么reverse_order方法会是查询结果按主键的降序
# 方式排序。
Client.where("orders_count > 10").reverse_order
# => select * from clients where orders_count > 10 order by clients.id DESC

# 8.5 rewhere方法覆盖where方法中指定的条件。
Article.where(trashed: true).where(trashed: false)

# 9 空关系
# none方法返回可以再链式调用中使用的、不包含任何记录的空关系。
# 对于可能返回零结果、但有需要在链式调用中使用的方法或作用域，可以使用none方法
# 来提供返回值。例如：
# 下面的visible_articles方法期待返回一个空Relation对象
@articles = current_user.visible_articles.where(name: params[:name])
def visible_articles
  case role
  when 'Country Manager'
    Article.where(country: country)
  when 'Reviewer'
    Article.published
  when 'Bad User'
    Article.none # => 如果这里返回[]或nil，会导致调用方出错
  end
end

# 10 只读对象
# 在关联中使用ActiveRecord提供的readonly方法，可以显示禁止修改任何返回对象。
# 如果尝试修改则会抛出异常。
client = Client.readonly.first
client.visits += 1
client.save
# 在上面的代码中，client被显示设置为制度对象，因此更新client.visits的值后
# 调用client.save会抛出异常。

# 11 在更新时锁定记录
# 11.1 乐观锁定
# 为了使用乐观锁定，数据表中需要有一个整数类型的lock_version字段。每次更新记录
# 时，ActiveRecord都会增加lock_version字段的值，如果更新请求中lock_version字段
# 的值比当前数据库中lock_version字段的值小，就会更新失败并抛出异常。
c1 = Client.find(1)
c2 = Client.find(1)

c1.first_name = "Michael"
c1.save

c2.name = "should fail"
c2.save # 抛出ActiveRecord::StaleobjectError

# 14 作用域
# 作用域允许我们把常用的查询定义为方法，然后通过在关联对象或模型上调用方法来
# 引用这些查询。就是自定义查询功能。
# 例如：
class Article < ApplicationRecord
  scope :published, ->{where(published: true)}
  # 这里就是自定义了一个方法叫published，其特定功能就是查询已出版的文章。
end
# 也可以这样写
class Article < ApplicationRecord
  def self.published
    where(published: true)
  end
end
# 在作用域中可以连接其他作用域：
class Article < ApplicationRecord
  scope :published, ->{where(published: true)}
  scope :published_and_commented, ->{published.where("comments_count > 0")}
  # published_and_commented自定义方法的工作流程就是：
  # 在published方法返回的Article对象集合上再执行where("comments_count > 0")查
  # 询。这样就能得到被评论过的所有文章对象，published_and_commented方法实现的功
  # 能正如其名。
end

# 14.1 传入参数
# 作用域方法可以接受参数，例如
class Article < ApplicationRecord
  scope :created_before, ->(time){where("created_at < ?", time)}
  # 自定义的方法(作用域)created_before可以传入时间参数，正如其命名的意思，在
  # 什么时间之前创建的文章。
end
# 调用作用域就和调用类方法一样
# 上面是scope写法
# 下面是类方法写法(前面也有写)
class Article < ApplicationRecord
  def self.created_before(time)
    where("created_at < ?", time)
  end
end
# 但是带参数的作用域，推荐改用类方法。因为使用类方法时，这些方法任然可以在关联
# 对象上访问：
category.articles.created_before(time)

# 14.2 使用条件
# 我们还可以在作用域中使用条件判断
class Article < ApplicationRecord
  scope :created_before, ->(time){
    where("created_at < ?", time) if time.present? }
    # 在查询之前先判断时间是否存在。
end
# 类方法写法
class Article < ApplicationRecord
  def self.created_before(time)
    where("created_at < ?", time) if time.present?
  end
end
# 但是不管判断条件是true还是false，作用域总是返回一个ActiveRecord::Relation对象
# 而当条件是false时，类方法返回的是nil，因此，当链接带有条件的类方法时，任何一个
# 条件是false都会引发NoMethodError异常。

# 14.3 应用默认作用域
# 要想在模型的所有查询中应用作用域，我们可以再这个模型上使用default_scope方法
# 就是这个模型的所有查询后面都会带上作用域里的查询。
# 例如：
class Client < ApplicationRecord
  default_scope{where(active: true)}
end

Client.new          # => #<Client id: nil, active: true>
Client.unscoped.new # => #<Client id: nil, avtive: nil>
# 执行new就会返回一个Client对象，该对象的id和active受到默认作用域的影响。

# 14.4 合并作用域
# 和Where子句一样，我们用AND来合并作用域
class User < ApplicationRecord
  scope :active, -> { where state: 'active' }
  scope :inactive, -> { where state: 'inactive' }
end
User.active.inactive
# => select "users".* from "users"."state" = 'active' 
#                     and "user"."state" = 'inactive'
# 我们可以混合使用scope和where方法，这样最后生成的SQL语句会使用and连接所有的
# 条件：
User.active.where(state: 'finished')
# => select "users".* from "users" where "users"."state" = 'active'
#                     and "users"."state" = 'finished'

# 如果使用Relation#merge方法，那么在发生条件冲突时总是最后的where子句起作用。
User.active.merge(User.inactive)
# => select "users".* from "users" where "users"."state" = 'inactive'

# 有一点要特别注意，default_scope总是在所有的scope和where之前起作用。
class User < ApplicationRecord
  default_scope { where state: 'pending' }
  scope :active, -> { where state: 'active' }
  scope :inactive, -> { where state: 'inactive' }
end
User.all
# => select * from users where users.state = 'pending'
User.active
# => select * from users where users.state = 'pending' 
#                        and users.state = 'active'
User.where(state: 'inactive')
# => select * from users where users.state = 'pending'
#                        and users.state = 'inactive'
# 这也说明了，default_scope方法会将其作用域加入到所有的查询中。

# 14.5 删除所有作用域
# 有需要的时候，可以使用unscoped方法无视模型中定义的默认作用于(default_scope)
Client.unscoped.load # 无视load作用域
Client.unscoped.all # 无视所有作用域
Client.where(published: false).unscoped.all
# unscoped方法也接受块作为参数
Client.unscoped{
  Client.created_before(Time.zone.now)
}

# 15 动态查找方法
# ActiveRecord为数据表中的每个字段都提供了查找方法(也就是动态查找方法)
# 例如对Client模型中的first_name字段
Client.find_by_first_name("张")
# 添加!调用会抛出异常
# 如果同时查询first_name和locked
Client.find_by_first_name_and_locked("张", true)

# 16 宏enum
# enum将整数字段映射为一组可能的值
class Book < ApplicationRecord
  enum availability: [:available, :unavailable]
end

# 上面的代码会自动创建用于查询模块的对应作用域，同时会添加用于转换状态和查询
# 当前状态的方法。

Book.available # 查询当前可用的书
# 或
Book.where(availability: :available)

book = Book.new(availability: :available)
book.available? # 查询当前书本是否可用，当前可用返回true
book.unavailable! # 转换当前书本状态为不可用
book.available? # 再次查询书本是否可用，返回结果为false

# 17 理解方法链
# 17.1 从多个数据表中检索过滤后的数据
Person
  .select('people.id, people.name, comments.text')
  .joins(:comments)
  .where('comments.created_at > ?', 1.week.ago)
# 这实际上就是Person.select.joins.where
# 会生成如下SQL语句：
# => select people.id, people.name, comments.text
#    from people
#    inner join comments
#    on comments.people_id = people.id
#    where comments.created_at > '2015-01-01'

# 17.2 从多个数据表中检索特定的数据
Person
  .select('people.id, people.name, companies.name')
  .joins(:company)
  .find_by('people.name' => 'John') # this should be the last sentence
# 返回单个对象的方法必须位于语句的末尾
# => select people.id, people.name, companies.name
#    from people
#    inner join companies
#    on companies.person_id = people.id
#    where people.name = 'John'
#    limit 1


# 18 查找或创建新对象
# 我们经常需要查找记录并在找不到记录时创建记录，这是我们可以使用
# find_or_create_by
Client.find_or_create_by(first_name: 'Andy')
# => select * from clients where (clients.first_name = 'Andy') limit 1
#    begin
#    insert into clients (created_at, first_name, locked, 
#    orders_count, updated_at) values ('2010-08-30 05:22:57', 'Andy', 1, NULL, 
#    '2011-08-30 05:22:57')
#    commit

# 18.3 find_or_initialize_by方法
# 与find_or_create_by方法类似，区别在于initialize方法调用的是new，这意味着新建
# 模型实例在内存中创建但还未存入数据库。
nick = Client.find_or_initialize_by(first_name: 'Nick')
nick.persisted? # 不存在就返回false
nick.new_record? # 返回true
# initialize方法生成SQL：
# => select * from clients where (clients.first_name = 'Nick') limit 1
# 要想把nick保存到数据库只需要调用save方法：
nick.save

# 19 使用SQL语句进行查找
Client.find_by_sql("
                   select * from clients
                   inner join orders on clients.id = orders.clinet_id
                   order by clients.created_at desc
                   ")
# 19.1 select_all方法
# find_by_sql方法有一个名为connection#select_all的近亲。
# 区别在于，select_all方法不会对这些查询结果实例化
# 而是返回一个散列构成的数组，其中每个散列表示一条记录
Client.connection.select_all("
                             select first_name, created_at from
                             clients where id = '1'")
# 返回的散列表构成的数组大概样式为：
# [
# {"first_name"=>"Rafael", "created_at"=>"2012-11-10 23:23:45.281189"},
# {"first_name"=>"Eileen", "created_at"=>"2013-12-09 11:22:35.221282"}
# ]

# 19.2 pluck方法
# pluck方法用于在模型对应的底层数据表单中查询单个或多个字段。它接受字段名的
# 列表为参数，并返回这些字段的值的数组，数组中的每个值都具有对应的数据类型。
# 例如：
# 不使用pluck方法前
Client.select(:id).map { |c| c.id }
# 或
Client.select(:id).map(&:id)
# 或
Client.select(:id, :name).map { |c| [c.id, c.name] }

# 使用pluck之后
Client.pluck(:id)
# 或
Client.pluck(:id, :name)
