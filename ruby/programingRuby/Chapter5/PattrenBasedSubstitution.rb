# 基于模式的替换
# String#sub和String#gsub方法查找能够匹配第一个参数的那部分字符串，同时用第二个参数替换它们
# String#sub执行一次替换，而String#gsub在匹配命中的每次都进行替换。

a = "the quick brown fox"
puts a.sub(/[aeiou]/, '*')
puts a.gsub(/[o]/, '*')
puts a.sub(/\s\S+/, '')
puts a.gsub(/\s\S+/, '')

# 两个函数的第二个参数可以是String或block。如果是block，匹配的字符串会被传递给block。
# 同时block的结果值会被替换到原先的字符串中。
puts a.sub(/^./) {|match| match.upcase}
puts a.gsub(/[aeiou]/) {|vowel| vowel.upcase}

# 转换单词首字母大写，词匹配首字符的模式是\b\w
print "\n"*5
def mixed_case(name)
  puts name.gsub(/\b\w/) {|first| first.upcase}
end

mixed_case("fats waller")
mixed_case("louis armstrong")
mixed_case("strength in numbers")

# 替换中的反斜线序列
# 早些时候我们注意到序列\1和\2等在模式中可用
# 同样的序列也可以作为sub和gsub的第二个参数
print "\n"*5
puts "fred:smith".sub(/(\w+):(\w+)/, '\2, \1')
puts "nercpyitno".gsub(/(.)(.)/, '\2\1')

# 其他的反斜线序列
print "\n"*5
str = '\\'
puts str.gsub(/\\/, '\\\\')
str = 'a\b\c'
puts str.gsub(/\\/, '\\\\\\\\')
puts str.gsub(/\\/, '\&\&') # \&表示最后的已匹配的字符串
puts str.gsub(/\\/, '\`\`')
# 如果使用gsub的block形式来替换，正则表达式引擎对反斜线的转义分析仅执行一次
puts str.gsub(/\\/) {'\\\\'}

print "\n"*6
def unescapeHTML(string)
  str = string.dup
  str.gsub!(/&(.*?);/n){
    match = $1.dup
    case match
    when /\Aamp\z/ni           then '&'
    when /\Aquot\z/ni          then '"'
    when /\Agt\z/ni            then '>'
    when /\Alt\z/ni            then '<'
    when /\A#(\d+)\z/ni        then Integer($1).chr
    when /\A#x([0-9a-f]+)\z/ni then $1.hex.chr
    end
  }
  str
end

puts unescapeHTML("1&lt;2 &amp;&amp; 4&gt;3")
puts unescapeHTML("&quot;A&quot; = &#65; = &#x41;")
