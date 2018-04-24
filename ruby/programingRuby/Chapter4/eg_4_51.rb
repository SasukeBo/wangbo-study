# You can use blocks to define a chunk of code that must be run under some kind of transactional control.
# For example, you'll often open a file, do something with its contents, and then want to ensure that the file is closed when you finish.
#
class File
  def File.open_and_process(*args)
    f = File.open(*args) # Collect the actual parameters passed to the method into an array named args.就是将参数放入array传递给方法
    yield f
    f.close()
  end
end

File.open_and_process("testfile", "r") do |file|
  while line = file.gets
    puts line
  end
end
class File
  def File.my_open(*args)
    result = file = File.new(*args)
    # If there's a block, pass in the file and close
    # the file when it returns
    if block_given?
      result = yield file
      file.close
    end
    return result
  end
end
# File.my_open("testfile", "r") {|line| puts line}
# puts File.my_open("testfile", "r")
