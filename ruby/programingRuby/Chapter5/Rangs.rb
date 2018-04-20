# 区间最自然的用法就是表达序列
# Ruby中使用'..'和'...'区间操作符来创建序列
# 两个点的形式创建闭合区间，三个点创建左闭右开区间
puts 1..10
puts 'a'..'z'
my_array = [1, 2, 3 ]
puts 0...my_array.length

# Ruby中，区间没有在内部用列表表示，如果有需要可以用to_a方法把区间转换成列表
puts (1..3).to_a
puts ('bar'..'bat').to_a

# 区间实现了许多方法可以让我们迭代它们，并且以多种方式测试它们的内容
digits = 0..9
print digits.include?(5), "  "
print digits.min, "  "
print digits.max, " \n"
print digits.reject {|i| i < 5 }, " \n"
# print digits.each {|digit| dial(digit) }, "\n"

# 区间也可以当做条件表达式使用。
while line = gets
  if line =~ /start/ .. line =~ /end/ then
    puts line
    break
  end
end

# 区间的最后一种用法是间隔测试，看看一些值是否会落入区间表达的间隔内
# 使用 === 操作符
puts (1..10) === 5
puts ('a'...'z') === 'z'
