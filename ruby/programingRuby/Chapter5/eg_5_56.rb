num = 81
6.times do
  puts "#{num.class}: #{num}"
  num *= num
end

1.upto(5) { |i| print i, " " }

puts 
some_file = File.open("some_file")
some_file.each do |line|
  v1, v2 = line.split
  print v1 + v2, " "
end
puts
# 从文件接收来的是String类型，直接做+运算是简单的将字符连接在一起
# 而在运算之前使用Integr可以转换为数字类型
some_file = File.open("some_file")
some_file.each do |line|
  v1, v2 = line.split
  print Integer(v1) + Integer(v2), " "
end
puts
