# 正则表达式是Regexp类型的对象。可以通过显示的调用构造函数或使用字面量形式/pattern/和%r{pattrn}来创建它们
a = Regexp.new('^\s*[a-z]')
b = /^\s*[a-z]/
c = %r{^\s*[a-z]}

# 一旦有了正则表达式对象，可以使用Regexp#match(String)方法或匹配操作符=~(肯定匹配)和!~(否定匹配)对字符串进行匹配。
# 匹配操作符至少有一个操作数必须是正则表达式。
=begin
name = "Fats Waller"
puts name =~ /F/
name = "fats waller"
puts b.match(name)
puts c =~ name
=end
# 匹配操作符返回匹配发生的字符位置

def show_regexp(a, re)
  if a =~ re
    puts "#{$`}<<#{$&}>>#{$'}"
  else
    puts "no match"
  end
end

=begin
show_regexp('very intresting', /t/)
show_regexp('Fats Waller', /a/)
show_regexp('Fats Waller', /ll/)
show_regexp('Fats Waller', /z/)

show_regexp('kangaroo', /angar/)
show_regexp('!@%&-_=+', /%&/)

# 特殊字符前面放置一个反斜线可以匹配它们的字面量
show_regexp('yes | no', /\|/)
show_regexp('yes (no)',/\(no\)/)
show_regexp('are you sure?', /e\?/)
=end

# 1.锚点匹配，^和$模式分别匹配行首和行尾。
# \A序列匹配字符串的开始
# \z和\Z匹配字符串的结尾

string = "this is\nthe time"
show_regexp(string, /^the/)
show_regexp(string, /is$/)
show_regexp(string, /\Athis/)
show_regexp(string, /\Athe/)
show_regexp(string, /\Zis/) # 不知道\Z模式是怎么用的
string = "this is the time\n"
show_regexp(string, /\ztime/)

# \b和\B模式分别匹配单词的边界和非单词的边界。
show_regexp(string, /\bis/)
show_regexp(string, /\Bis/)

# 2.字符类
print "\n"*10
s = 'Price $12.'
show_regexp(s, /[aeiou]/)
show_regexp(s, /[\s]/)
show_regexp(s, /[[:digit:]][[:digit:]]/) # 可以看出字符类匹配，每个[]表示一个字符
show_regexp(s, /[[:space:]]/)
show_regexp(s, /[[:punct:]]/)

print "\n"*10
a = 'see [Design Pattrens-page 123]'
show_regexp(a, /[A-F]/)
show_regexp(a, /[A-Fa-f]/)
show_regexp(a, /[0-9]/)
show_regexp(a, /[0-9][0-9]/)

print "\n"*10
show_regexp(a, /[]]/)
show_regexp(a, /[-]/)
show_regexp(a, /[^a-z]/) # 把^直接放在开始的方括号后面会对字符类求反，此处求反结果表示匹配任何非小写字母字符
show_regexp(a, /[^a-z\s]/) # 非小写字母且非空格的字符

# 一些字符类使用的很频繁，Ruby为它们提供了缩写形式，例如\s匹配空格字符，\d匹配数字
print "\n"*10
b = 'It costs $12.'
show_regexp(b, /\s/)
show_regexp(b, /\d\d/)

# 最后，出现在方括号外面的.号，表示出回车换行符之外的任何字符，不过在多行模式下它也会匹配回车换行符
show_regexp(b, /c.s/)
show_regexp(b, /./)
show_regexp(b, /\./)

# 3.重复匹配
# 对于之前的例子/\s*\|\s*/，匹配被任意数目的空格围绕的竖线。
# 因此看起来星号(*)指的是任意数目。
# 实际上星号只是多个修饰符中的一个
# r* 匹配零个或多个r的出现
# r+ 匹配一个或多个r的出现
# r？匹配领个或一个r的出现
# r{m,n} 匹配至少m次和最多n次r的出现
# r{m,}  匹配至少m次r的出现
# r{m}   指定匹配m次r的出现
#
a = "The moon is made of cheese"
print "\n"*10
show_regexp(a, /\w+/)
show_regexp(a, /\s.*\s/)
show_regexp(a, /\s.*?\s/)
show_regexp(a, /[aeiou]{2,99}/)
show_regexp(a, /mo?o/)
