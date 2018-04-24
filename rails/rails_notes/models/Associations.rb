# 2.2 has_one 关联
# has_one 关联也会建立两个模型之间的一对一关系，但语义和结果有点不一样。
# 这种关联表示模型的实例包含或拥有另一个模型的实例。
# 例如，在程序中，每个供应商只有一个账户，可以这么定义供应商模型:
class Supplier < ActiveRecord::Base
  has_one :account
end

# 相应的迁移如下：
class CreateSuppliers < ActiveRecord::Migration
  def change
    create_table :suppliers do |t|
      t.string :name
      t.timestamps
    end

    create_table :accounts do |t|
      t.belongs_to :supplier
      t.string :account_number
      t.timestamps
    end
  end
end

# 2.3 has_mang 关联
# has_many 关联建立两个模型之间的一对多关系。在belongs_to关联的另一端经常会
# 用到这个关联。例如，在程序中有顾客和订单两个模型，顾客模型可以这么定义：
class Customer < ActiveRecord::Base
  has_many :orders
end

# 相应的迁移如下：
class CreateCustomers < ActiveRecord::Migration
  def change
    create_table :customers do |t|
      t.string :name
      t.timestamps
    end

    create_table :orders do |t|
      t.belongs_to :customer
      t.datetime :order_date
      t.timestamps
    end
  end
end

# 2.4 has_many :through 关联
# 建立两个模型之间的多对多关联。这种关联表示一个模型的实例可以借由第三个模型，
# 拥有零个和多个另一个模型的实例。例如，看病过程中，病人要和医生预约时间。
# 关联声明如下：
class Physician < ActiveRecord::Base
  has_many :appointments
  has_many :patients, through: appointments
end

class Appointment < ActiveRecord::Base
  belongs_to :physician
  belongs_to :patient
end

class Patient < ActiveRecord::Base
  has_many :appointments
  has_many :physicians, through: :appointments
end

# 相应的迁移如下：

class CreateAppointments < AvtiveRecord::Migration
  def change
    create_table :physicians do |t|
      t.string :name
      t.timestamps
    end

    create_table :patients do |t|
      t.string :name
      t.timestamps
    end

    create_table :appointments do |t|
      t.belongs_to :physician
      t.belongs_to :patient
      t.datetime :appointment_date
      t.timestamps
    end
  end
end

# has_many :through 还可以用来简化嵌套的has_many关联。例如，一个文档分为多个部
# 分，每个部分又有多个段落，如果想使用简单的方式获取文档中的所有段落，可以这么
# 做：
class Document < ActiveRecord::Base
  has_many :sections
  has_many :paragrahs, through: :sections
end

class Section < ActiveRecord::Base
  belongs_to :document
  has_many :paragraphs
end

class Paragraph < ActiveRecord::Base
  belongs_to :section
end

# 加上through: :sections 后，Rails就能理解这段代码：
# @document.paragraphs

# 2.5 has_one :through 关联
# 建立两个模型之间一对一的关系。这种关联表示一个模型通过第三个模型拥有另一个模
# 型的实例。例如，每个供应商只有一个账户，而且每个账户都有一个历史账户，那么就
# 可以这样定义模型：

class Supplier < ActiveRecord::Base
  has_one :account
  has_one :account_history, through: :account
end

class Account < ActiveRecord::Base
  belongs_to :supplier
  has_one :account_history
end

class AccountHistory < ActiveRecord::Base
  belongs_to :account
end

# 相应的迁移如下

class CreateAccountHistories < ActiveRecord::Migration
  def change
    create_table :suppliers do |t|
      t.string :name
      t.timestamps
    end

    create_table :accounts do |t|
      t.belongs_to :supplier
      t.string :account_number
      t.timestamps
    end

    create_table :account_histories do |t|
      t.belongs_to :account
      t.integer :credit_rating
      t.timestamps
    end
  end
end

# 2.6 has_and_belongs_to_many 关联
# 建立两个模型之间的多对多关系，不借助第三个模型。例如，程序中有装配体和零件
# 两个模型，每个装配体中有多个零件，每个零件又可用于多个装配体，这是可以按照下
# 面的方式定义模型：

class Assembly < ActiveRecord::Base
  has_and_belongs_to_many :parts
end

class Part < ActiveRecord::Base
  has_and_belongs_to_many :assemblies
end

# 相应迁移如下：

class CreateAssembliesAndParts < ActiveRecord::Migration
  def change
    create_table :assemblies do |t|
      t.string :name
      t.timestamps
    end

    create_table :parts do |t|
      t.string :part_number
      t.timestamps
    end

    create_tables :assemblies_parts, id: false do |t|
      t.belongs_to :assembly
      t.belongs_to :part
    end
  end
end

# 2.7 使用belongs_to还是has_one
# 一对一的关联应该考虑谁是谁的外键，也就是谁的模型声明使用belongs_to，谁的模型
# 声明使用has_one

# 3.4 控制关联的作用域
# 默认情况下，关联只会查找当前模块作用域中的对象。
module MyApplication
  module Business
    class Supplier < ActiveRecord::Base
      has_one :account
    end
  end

  module Billing
    class Account < ActiveRecord::Base
      belongs_to :supplier
    end
  end
end

# 上面这段代码就不能正常运行，因为Supplier和Account在不同的作用域。
# 要想正常建立关联，就必须在声明关联时指定完整的类名。
has_one :account, class_name: "MyApplication::Billing::Account"

belongs_to :supplier, class_name: "MyApplication::Business::Supplier"

# 3.5 双向关联
# 一般情况下，都要求能在关联的两端进行操作。
class Customer < ActiveRecord::Base
  has_many :orders
end
class Order < ActiveRecord::Base
  belongs_to :customer
end

# 执行下面操作:
c = Customer.first
o = c.orders.first
c.first_name == o.customer.first_name # => true
c.first_name = 'Manny'
c.first_name == o.customer.first_name # => false

# 因为c和o.customer在内存中是同一数据的两种表示，修改其中一个并不会影响另一个
# 的值，所以需要:inverse_of选项，可以告知两个模型之间的数据同步。
class Customer < ActiveRecord::Base
  has_many :orders, inverse_of: :customer
end

class Order < ActiveRecord::Base
  belongs_to :customer, inverse_of: :orders
end
# 这么修改之后，ActiveRecord就只会加载一个对象，避免数据的不一致。
# inverse_of使用有时会受限制，详情请查阅官网。



# 4.关联详解
# 4.1 belongs_to 关联详解
# 4.1.1 belongs_to 关联添加的方法
# 声明belongs_to关联后，所在的类会获得五个和关联相关的方法：
=begin
association(force_reload = false)
association=(associate)
build_association(attributes = {})
create_association(attributes = {})
create_association!(attributes = {})
=end
# 这五个方法中association字段被替换为belongs_to方法接收的第一个参数
# 比如：
belongs_to :customer
# 生成方法例如
create_customer
# 这些方法的作用详情查阅官网文档

# 4.1.2 belongs_to 方法的选项

# 4.3 has_many 关联详解
collection(force_reload = false)
# collection方法返回一个数组，包含所有关联的对象，没有则返回空数组。
collection<<(object, ...)
# collection<<方法向关联对象数组添加一个或多个对象，并把加入的个对象的外键设为
# 调用此方法的模型的主键。
@customer.orders << @order1

collection.delete
# collection.delete 方法从关联对象数组中删除一个或多个对象，并把删除的对象的
# 外键设置为NULL。
@customer.orders.delete(@order1)

collection.destroy(object, ...)
# collection.destroy方法在关联对象上调用destroy方法，从关联对象数组中删除一个
# 或多个对象。
@customer.orders.destroy(@order1)
# 对象会从数据库中删除，无视:dependent选项。

collection=objects
# collection= 让关联对象数组只包含指定的对象，根据需求会添加或删除对象。

collection_singular_ids
# 返回一个数组，包含关联对象数组中个对象的ID。
@order_ids = @customer.order_ids
























