# Variables are used to keep track of objects: each variable holds a refernce to an object.

person = "Tim"
# 'id' is deprecated and replaced with object_id
puts person.object_id, person.class, person

# So, is a variable an object? In Ruby, the answer is “no.” A variable is simply a reference to an object.

person1 = 'Tim'
person2 = person1
person1[0] = 'J'

puts person1, person2
# We changed the first character of person1, but both person1 and person2 changed from "Tim" to "Jim".
# It all comes back to the fact thae variables hold refernces to objects, not the objects themselves.
# We can also prevent anyone to changing a particular object by freezing it.
# For example:
person1.freeze
person2[0] = 'T'
# And the result may told you :can't modify frozen string !
