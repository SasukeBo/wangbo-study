# Ruby 方法定义可以指定默认的参数值
# Defininig a Method
def cool_dude(arg1 = "Miles", arg2 = "Coltrane", arg3 = "Roach")
  puts "#{arg1}, #{arg2}, #{arg3}."
end

cool_dude
cool_dude("Bart")
cool_dude("Bart", "Elwood")
cool_dude("Bart", "Elwood", "Linus")

# 可变长度的参数列表
def varargs(arg1, *rest)
  puts "Got #{arg1} and #{rest.join(', ')}"
end

print "\n"*6
varargs("one")
varargs("one", "two")
varargs "one", "two", "three"

# 方法和Block
def take_block(p1)
  if block_given?
    yield(p1)
  else
    puts p1
  end
end

print "\n"*6
take_block("no block")
take_block("no block") {|s| puts s.sub(/no /,'has a ')}

# 如果方法定义的最后一个参数前缀是&，那么所关联的block会被转换为一个proc对象，然后赋值给这个参数
class TaxCalculator
  def initialize(name, &block)
    @name, @block = name, block
  end
  def get_tax(amount)
    puts "#@name on #{amount} = #{ @block.call(amount)}"
    # 记住如何将block作为对象调用call方法执行block内容
  end
end

tc = TaxCalculator.new("Sales tax") {|amt| amt * 0.075 }
print "\n"*6
tc.get_tax(100)
tc.get_tax(250)

# Calling a Method 调用方法
# 对类方法或模块方法来说，接受者是类或模块的名字
print "\n"*6
puts File.size("../Chapter4/testfile")
puts Math.sin(Math::PI/4)
puts self.class
puts self.frozen?
puts frozen?
puts self.object_id
puts object_id

print "\n"*6
# Method Return Values方法返回值
# 每个方法被调用都会返回一个值，方法的值是执行中最后一个语句执行的结果
# return语句可以带参数从方法中返回
def meth_one
  puts "one"
end
meth_one

def meth_two(arg)
  case
  when arg > 0
    puts "positive"
  when arg < 0
    puts "negative"
  else
    puts "zero"
  end
end

meth_two(23)
meth_two(0)

def meth_three
  100.times do |num|
    square = num * num
    return num, square if square > 1000
  end
end
print meth_three, "\n"
num, square = meth_three
print num, " ", square, "\n"

print "\n"*6
def five(a, b, c, d, e)
  puts "I was passed #{a} #{b} #{c} #{d} #{e}"
end

five(1, 2, 3, 4, 5)
five(1, 2, 3, *['a', 'b'])
five(*(10..14).to_a)
# 当使用array作为参数时，需要在前面使用*来分解array使每个成员都被视为一个参数
#

# 让block更加动态
=begin
print "(t)imes or (p)lus: \n"
times = gets
print "number: \n"
number = Integer(gets)
if times =~ /^t/
  puts((1..10).collect {|n| n * number }.join(", "))
elsif times =~ /^p/
  puts((1..10).collect {|n| n + number }.join(", "))
else
  puts "worry input!"
end
=end

# 虽然这可以实现功能，但是每个if语句后面重复实质上等价的代码，颇为丑陋。
# 如果可以将完成计算的block抽取出来，代码就漂亮很多
print "(t)imes or (p)lus: \n"
times = gets
print "number: \n"
number = Integer(gets)
if times =~ /^t/
  calc = lambda {|n| n * number }
else
  calc = lambda {|n| n + number}
end
puts ((1..10).collect(&calc).join(", "))
# 如果方法的最后一个参数前有&符号，Ruby认为它是一个proc对象，并将其从参数列表中删除，并将proc对象转换为一个block然后关联到该方法
