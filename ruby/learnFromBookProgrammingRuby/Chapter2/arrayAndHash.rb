#array以integer对象为索引，而hash可以以任何类型对象作为索引
#ruby array indices start at zero.
a = [ 1, 'cat', 3.14 ] #array with three kinds of elements

#access the first element
puts a[0]

#set the third element
a[2] = nil  #ruby 中的nil(null)是一个对象
puts a[2]

#dump out the array
puts a

#使用 %w 可以取代array中的 ',' 号,如下
b = %w{ ant bee cat dog elk }
puts b

#hash的每个单元需要两个对象，一个作为索引key，另一个作为值，例如
inst_section = {
  'cello'=>'string',
  'clarinet'=>'woodwind',
  'drum'=>'percussion',
  'oboe'=>'woodwind',
  'trumpt'=>'brass',
  'violin'=>'string'
}
puts inst_section['oboe']
puts inst_section['cello']
puts inst_section['bassoon']

histogram = Hash.new(1)
puts histogram['key1']
histogram['key1'] = histogram['key1'] + 1
puts histogram['key1']
