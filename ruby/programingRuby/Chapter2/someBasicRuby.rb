def say_goodnight(name)#括号不是必须的
  result = "Good night, " + name
  return result
end
#Time for bed ...
puts say_goodnight("John-Boy")
puts say_goodnight("Marry-Ellen")

#puts方法也可以加上括号，如下
puts(say_goodnight("wangbo")) #但是建议简单情况下puts不要使用括号

puts "and good night\nGrandma"

def say_goodnight2(name)
  result = "Good night, #{name}"
  return result
end
puts say_goodnight2('Pa')


def say_goodnight3(name)
  result = "Good night, #{name.capitalize}"#将字符串首字母变为大写
  return result
end
puts say_goodnight3('uncle')

$greeting = "Hello" #$greeting is a global variable全局变量
@name = "Prudence" #@name is an instance variable实例变量
puts "#$greeting, #@name"


#更加简化的方式，这样可以摆脱临时变量和return的声i明
def say_goodnight4(name)
  "Good night, #{name}"
end
puts say_goodnight4('Ma')

=begin
全局变量名以符号$开头，实例变量名以@开头，类变量名以@@开头
类名、模块名和常量名必须以大写字母开头
=end
