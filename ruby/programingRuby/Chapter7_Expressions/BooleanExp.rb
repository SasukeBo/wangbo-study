# Ruby对真值的定义很简单，任何不适nil或者敞亮false的值都为真
# 数字0和长度为0的字符串也不是假值，这和其他语言有点不同。
# 优先级 ：&& > and = or >||
puts defined? $_
puts defined? yield

# 操作符and，or，&&， ||实际上返回首个决定条件真伪的参数的值
a = nil and true
false and true
99 and false
puts (99 and nil)
a = 99 and "cat"
a = (99 and "cat")
puts a << "sasuke"
