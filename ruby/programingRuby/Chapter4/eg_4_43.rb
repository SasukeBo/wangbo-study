# Hashes (sometimes known as associative arrays, maps, or dictionaries) are similar to arrays in that they are indexed collections of object references.
# The example that follows uses hash literals: a list of key => value pairs between braces.
h = { 'dog' => 'canine', 'cat' => 'feline', 'donkey' => 'asinine' }
puts h.length
puts h['dog']
h['cow'] = 'bovine'
h[12] = 'dodecine'
h['cat'] = 99
puts h

# Compared with arrays, hashes have one significant advantage: they can use any object as an index.
