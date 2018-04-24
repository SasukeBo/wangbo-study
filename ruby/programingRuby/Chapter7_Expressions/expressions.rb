# 几乎所有的东西都是表达式
# if和case语句都返回最后执行的表达式的值
# For example:(本例中部分对象没有实例化，不可以运行)
=begin
song_type = if song.mp3_type == MP3::Jazz
              if song.written < Date.new(1935, 1, 1)
                Song::TradJazz
              else
                Song::Jazz
              end
            else
              Song::Other
            end
rating = case votes_cast
         when 0...10    then Rating::SkipThisOne
         when 10...50   then Rating::CouldCoBetter
         else                Rating::Rave
         end
=end

# 运算符表达式Operator Expressions
# 因为任何东西都是对象，而且可以重新定义实例方法，For Example
=begin
class Fixnum
  alias old_plus + 
  def +(other)
    old_plus(other).succ
  end
end

puts 1 + 2
a = 3
puts a += 4
puts a + a
=end

# 如果你用反引号（``），或者以%x为前缀的分界形式括起一个字符串，默认情况下它会被当做底层操作系统的命令来执行，表达式的返回值就是该命令的标准输出。
puts `date`
puts `ls`.split[0]
puts %x{echo "hello there"}

alias old_backquote `
def `(cmd)
  result = old_backquote(cmd)
  if $? != 0
    fail "Command #{cmd} failed: #$?"
  end
  result
end

print `date`
# print `data`
#

# If and Unless Expressions
# 如果将If语句分不到多行上，那么可以不用then关键字
=begin
if song.artist == "Gillespie"
  handle = "Dizzy"
elsif song.artist == "parker"
  handle = "unknown"
end
=end

# 冒号可以替代then
# if song.artist == "Gillespie": handle = "Dizzy"
# end
#
# Ruby 还有一个否定形式的if语句
=begin
unless song.duration > 180
  cost = 0.25
else
  cost = 0.35
end
=end

# If和Unless修饰符
=begin
mon, day, year = $1, $2, $3 if date =~ /(\d\d)-(\d\d)-(\d\d)/
puts "a = #{a}" if debug
print total unless total.zero?
=end

# Case表达式
=begin
year = gets
kind = case year
       when 1850..1889 then "Blues"
       when 1890..1909 then "Ragtime"
       when 1910..1929 then "New Orleans Jazz"
       when 1930..1939 then "Swing"
       when 1940..1950 then "Bebop"
       else "jazz"
       end
puts kind
=end

# Loops 循环
# while 和 until
=begin
file = File.open("testfile")
while line = file.gets
  puts(line) if line =~ /third/ .. line =~ /fifth/
end
=end

File.foreach("testfile") do |line|
  #if (($. == 1) || line =~ /eig/) .. (($. == 3) || line =~ /nin/)
  if (($. == 1) || ($. == 8)) .. (($. == 3) || ($. == 9))
    print line
  end
end

# 当使用while和until做语句修饰符时，如果被修饰的语句是begin/end块，则至少执行一次块内代码！
begin
  print "Goodbye\n"
end while false

# Iterators迭代器
3.times do
  print "Ho! "
end
0.upto(9) do |x|
  print x, " "
end
0.step(12, 3) {|x| print x, " "}
[1, 1, 2, 3, 5].each {|val| print val, ' '}
File.open("testfile").grep(/d$/) do |line|
  # 正则表达式/d$/以$结尾表示尾部匹配
  puts line
end

# Ruby还提供了内建的称谓loop的迭代器
=begin
loop do
  # block ...
end
=end

# For ... In
=begin
for song in songlist
  song.paly
end

# 等价于下面这段代码
songlist.each do |song|
  song.play
end
=end

for i in ['fee', 'fi', 'fo', 'fum']
  print i, " "
end
for i in 1..3
  print i, ' '
end
for i in File.open("testfile").find_all {|line| line =~ /d$/}
  print i.chomp, ' '
end

print "\n"*6
# 只要你的类支持each方法，你就可以使用for循环去遍历它的对象
class Periods
  def each
    yield "Classical"
    yield "Jazz"
    yield "Rock"
  end
end
periods = Periods.new
for genre in periods
  print genre, ' '
end

# Break，Redo和Next
# 循环控制结构break，redo和next可以让你改变循环或迭代的正常流程
print "\n"*6
i = 0
loop do 
  i += 1
  next if i < 3
  print i
  break if i >4
end

# redo语句使得一个循环重新执行当前迭代。
# 而retry语句从头执行一个循环
=begin
for i in 1..100
  print "Now at #{i}. Restart? "
  retry if gets =~ /^y/i
end
=end

print "\n"*6
def do_until(cond)
  if cond then break
  else 
    yield
    retry
  end
end
i = 0
do_until(i > 10) do
  print i, " "
  i += 1
end

