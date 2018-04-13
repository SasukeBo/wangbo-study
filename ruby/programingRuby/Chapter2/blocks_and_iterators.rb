#Code bloks are just chunks of code between braces or between do ... and.
#{ puts "Hello" } #this is a block
=begin
do                    #and so is this
  club.enroll(person)
  person.socialize
end
=end

#Once you have created a block, you can associate it with a call to a method.
#greet { puts "Hi" }
#If the method has parameters, they appear before the block.
def verbose_greet(name, user)
  puts "#{name}"
  yield #yeild作用就是调用块block里的程序段
  puts "#{user}"
end
verbose_greet("wangbo", "sasuke") { puts "Hi" }

def call_block
  puts "Start of method"
  yield
  yield
  puts "End of method"
end
call_block {puts "In the blok"}

#You can provide parameters to the call to yield:these will be passed to the block.
#Within the block, you will list the names of the arguments to receive these parameters between vertical bars(|).
def call_block2
  yield("hello", 99)
end
call_block2 {|str, num| puts "#{str} and #{num}"}

#blocks can also be used to return successive elements from some kind of collection, such as an array.
animals = %w( ant bee cat dog elk ) 
animals.each {|animal| puts "I know #{animal}"}

[ 'cat', 'dog', 'horse' ].each {|name| print name, " "}
5.times { print "*" } #打印5次* here we ask the object 5 to call a block five times and then ask the object 3 to call a block, passing in successive values until it reaches 6.
3.upto(6) {|i| print i}
('a'..'e').each {|char| print char }
