# The class Array holds a cllection of object references.

=begin
a = [ 3.14159, "pie", 99 ]
puts a.class
puts a.length
a.each{|v| puts v}
puts a[3]

b = Array.new
puts b.class, b.length
b[0] = "second"
b[1] = "array"
puts b
#=end

# Index an array with a negative integer, and it counts from the end.

a = [ 1, 3, 5, 7, 9 ]
puts a[-1]
puts a[-2]
puts a[-99]

# You can also index arrays with a pair of numbers, [ start, count ].
puts a[1, 3]
puts a[3, 1]
puts a[-3, 2]

# Finally you can index arrays using rangs, in which start an end postions are separated by two or three periods. The two-period form includes the end position, and the three-period form does not.
puts
puts a[1..3]
puts a[1...3]
puts a[3..3]
puts a[-3..-1]
=end
# If the index to [  ] = is two numbers (a start and a length) or a range, then those elements in the original array are replaced by whatever is on the right side of the assignment.
a = [ 1, 3, 5, 7, 9 ]
a[2, 2] = 'cat'
a[2, 0] = 'dog'
a[1, 1] = [ 9, 8, 7 ]
a[0..3] = []
a[5..6] = 99, 98
puts a
