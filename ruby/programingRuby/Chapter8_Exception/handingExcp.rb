# 8.2 异常处理
# 此处展示一些异常处理代码，不能运行
op_file = File.open(opfile_name, "w")
begin
  # 这段代码引发的异常会被
  # 下面的rescue语句捕获
  while data = socket.read(512)
    op_file.write(data)
  end
  rescue SystemCallError
    $stderr.print "IO failed: " + $!
    op_file.close
    File.delete(opfile_name)
    raise
end

# 当异常背引发是，Ruby将相关
# Exception对象的引用放在全局
# 变量$!中，这与任何随后的异常
# 处理不相干
#
# 我们可以不带任何参数调用raise，它会重新引发$!中的异常。
# 这个技术允许我们先编写代码过滤掉一些异常，再把不能处理的异常传递给更高层次。
#

# begin 块中可以有多个rescue子句，每个rescue可以指示捕获多个异常。
# 在rescue子句的结束处，可以提供一个局部变量来接收匹配的异常。
begin
  eval string
rescue SyntaxError, NameError => boom
  print "String doesn't compile: " + boom
rescue StandardError => bang
  print "Error running script: " + bang
end

# 8.2.1 系统错误
# 当对操作系统的调用返回错误码时，会引发系统错误
# 8.2.2 善后
f = File.open("testfile")
begin
  # .. process
rescue
  # .. handle error
ensure
  f.close unless f.nil?
  # 不管block是否正常退出， 是否引发并rescue异常
  # 这个ensure块总会得到运行
end

# 8.2.3 再次执行
# 有时候也许可以纠正异常的原因。在rescue子句中使用retry语句去重复执行整个begin/end块
# 但是小心这可能会导致无限循环
@esmtp = true
begin
  # 首先尝试扩展登录，如果因为服务器不支持而失败
  # 则使用正常登录
  if @esmtp then
    @command.ehlo(helodom)
  else
    @command.helo(helodom)
  end
rescue ProtocolError
  if @esmtp then
    @esmtp = false
    retry
  else
    raise
  end
end

# 8.3 引发异常
# 可以使用Kernel.raise方法在代码中引发异常
raise
raise "bad mp3 encoding"
raise InterfaceException, "Keyboard failure", caller

raise "Missing name" if name.nil?
if i >= names.size
  raise IndexError, "#{i} >= size (#{names.size})"
end
raise ArgumentError, "Name too big ", caller

# 8.3.1 添加信息到异常
class RetryException < RuntimeError
  attr :ok_to_retry
  def initialize(ok_to_retry)
    @ok_to_retry = ok_to_retry
  end
end
# 在下面的代码里面，发生了一个暂时的错误
def read_data(socket)
  data = socekt.read(512)
  if data.nil?
    raise RetryException.new(true), "transient read error"
  end
  # .. 正常处理
end
# 再上一级的调用栈处理了异常
begin
  stuff = read_data(socket)
  # .. process stuff
rescue RetryException => detail
  retry if detail.ok_to_retry
  raise
end

# 8.4 捕获和抛出 Catch and Throw
catch (:done) do
  while line = gets
    throw :done unless fileds = line.split(/\t/)
    songlist.add(Song.new(*fields))
  end
  songlist.play
end
# catch 定义给定名称为标签的block，这个block会正常执行直到遇到throw为止

# 下面的例子中，如果在响应任意提示符时键入！，使用throw终止与用户交互
def prompt_and_get(prompt)
  print prompt
  res = readline.chomp
  throw :quit_requested if res == "!"
  res
end

catch :quit_requested do
  name = prompt_and_get("Name: ")
  age = prompt_and_get("Age: ")
  sex = prompt_and_get("Sex: ")
  # ..
  # 处理信息
end
# 这个例子说明了throw不是必须出现在catch的静态作用域内

