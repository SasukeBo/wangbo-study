# Whenever a yield is executed, it invokes the code in thr block. 

=begin
def three_times
  yield
  yield
  yield
end
three_times { puts "Hello" }
three_times { puts "Good night" }



def fib_up_to(max)
  i1, i2 = 1, 1
  while i1 <= max
    yield i1
    i1, i2 = i2, i1 + i2
  end
end
fib_up_to(1000) {
  |f| print f, " "
}
=end

=begin
a = [1, 2]
b = 'cat'
a.each {|b| c = b * a[1] }
puts a
puts b
puts defined?(c)



class Array
  def find
    for i in 0...size
      value = self[i]
      return value if yield(value)
    end
    retuen nil
  end
end

puts [1, 3, 5, 7, 9].find {|v| v*v > 30 }

# each is a simple iterator
[1, 3, 5, 7, 9].each {|i| puts i }
# collect is also a iterator
["H", "A", "L"].collect {|x| print x.succ, " " }

f = File.open("testfile")
f.each do |line|
  puts line
end
f.close
=end

puts [1, 3, 5, 7].inject(4) {|sum, element| sum + element }
puts [1, 3, 5, 7].inject(1) {|product, element| product * element }
# inject 将参数作为第一个sum或product，然后用array中的element去做block中的运算，并将最终的运算结果返回。如果inject不带参数，则将array中的第一个元素作为product




