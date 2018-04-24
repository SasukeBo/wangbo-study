# 9.1 命名空间Namespaces
# 当你编程越来越大的Ruby程序时，会发现许多代码可以重用
# 将相关的例程组成一个库是合适的。这样这些代码可以被其他不同Ruby程序共享。
# 不同代码段可能会有命名冲突，而模块定义了一个namespace可以解决这个问题
# 例如

module Trig
  PI = 3.141592654
  def Trig.sin(x)
    # ..
  end
  def Trig.cos(x)
    # ..
  end
end

module Moral
  VERY_BAD = 0
  BAD      = 1
  def Moral.sin(badness)
    # ..
  end
end

# 如果第三方程序想要使用这些模块，它可以简单地加载这两个文件
require 'trig'
require 'moral'
y = Trig.sin(Trig::PI/4)
wrongdoing = Moral.sin(Moral::VERY_BAD)
# 9.2 Mixin
# 模块提供了一种称为mixin的功能，极大地消除了多重继承的需要
# 模块没有实例。
# 可以在类的定义中include一个模块，当包含发生时，模块所有的实例方法瞬间在类中也可以使用了
# 它们被混入了(mix in)。例如：
module Debug
  def initialize(name)
    @name = name
  end
  def name
    @name
  end
  def who_am_i?
    puts "#{self.class.name} (\##{self.object_id}): #{self.name.to_s}"
  end
end
class Phonograph
  include Debug
  # ...
end
class EightTrack
  include Debug
  # ...
end
ph = Phonograph.new("West End Blues")
et = EightTrack.new("Surrealistic Pillow")

ph.who_am_i?
et.who_am_i?

# 通过包含Debug模块，Phonograph和EightTrack都可以访问who_am_i?这个实例方法
# Ruby的include是产生一个指定指向模块的引用
# 用Song类来尝试一下，令它们基于时长来进行比较
# Comparable mixin 向类中添加比较操作符以及between?方法
class Song
  include Comparable
  def initialize(name, artist, duration)
    @name = name 
    @artist = artist
    @duration = duration
  end
  def duration
    @duration
  end
  def<=>(other)
    self.duration <=> other.duration
  end
end

song1 = Song.new("My way", "Sinatra", 225)
song2 = Song.new("bicyclops", "Fleck", 260)

puts song1 <=> song2
puts song1 < song2
puts song1 == song2
puts song1 > song2

class VowelFinder
  include Enumerable
  def initialize(string)
    @string = string
  end
  def each
    @string.scan(/[aeiou]/) do |vowel|
      yield vowel
    end
  end
end
# vf = VowelFinder.new("the quick brown fox jumped")
# puts vf.inject {|v, n| v + n}
# 调用inject，当作用于数字将返回算术和
# 当作用于字符串时将返回串联的字符串。
# 我们也可以使用一个模块来封装这个功能
module Summable
  def sum
    puts inject {|v,n| v + n}
  end
end

class Array
  include Summable
end
class Range
  include Summable
end
class VowelFinder
  include Summable
end

puts [1, 2, 3, 4, 5].sum
('a'..'m').sum
vf = VowelFinder.new("the quick brown fox jumped")
vf.sum


# 9.4.1 Mixin 中的实例变量
# 下面的例子module会向包含它的类中添加实例变量
module Observable
  def observers
    @observer_list ||= []
  end
  def add_observer(obj)
    observers << obj
  end
  def notify_observers
    observers.each {|o| o.update }
  end
end
# 不过这种行为也给我们带来了风险，可能会发生实例变量冲突的问题。例如下面的实例：
class TelescopeSchedular
  # other classes can register to get notifications
  # when the schedule changes
  include Observable

  def initialize
    @observer_list = [] # folks with telescope time
  end
  def add_viewer(viewer)
    @observer_list << viewer
  end
  # ...
end


# 多数时候mixin模块并不带有自己的实例变量，它们使用访问方法从客户对象中取得数据
module Test
  State = {}
  def state=(value)
    State[object_id] = value
  end
  def state
    State[object_id]
  end
end

class Client
  include Test
end

c1 = Client.new
c2 = Client.new
c1.state = 'cat'
c2.state = 'dog'
puts c1.state
puts c2.state

# 9.5 包含其他文件
# Ruby 有两个语句来完成文件导入
# load方法，每次load都会将指定的Ruby源文件包含进来
# load 'filename.rb'
# 更常见的是使用require方法来加载指定的文件，且只加载一次
# require 'filename'
# 被夹在的文件中局部变量不会蔓延到加载它们的所在的范围中。
# 例如当前路径下有个文件为included.rb
# 下面当我们把它包含到本文件之后将会发生什么
a = 'cat'
b = 'dog'
require './included.rb'
print a, ' ', b, " \n"
puts b()
