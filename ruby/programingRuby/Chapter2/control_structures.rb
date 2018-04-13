#if else控制结构示例
count = 1
tries = 3
if count > 10
  puts "Try again"
elsif tries == 3
  puts "You lose"
else
  puts "Enter a number"
end

#while控制结构示例
=begin
while weight < 100 and num_pallets <= 30
  pallet = next_pallet()
  weight += pallet.weight
  num_pallets +=1
end
=end

#most statements in Ruby return a value ,can use them as conditions eg:
line = 'ABC'
gets = 'ABC'
while line = gets 
  puts line.downcase
  break #否则无限循环
end

radiation = 3001
if radiation > 3000
  puts "Danger, Will Robinson"
end
#另一种书写模式
puts "Danger, Will Robinson" if radiation > 3000

#while 的两种书写模式
square = 2
while square < 1000
  square = square*square
end
puts square

square = 2
square = square*square while square < 1000
puts square




