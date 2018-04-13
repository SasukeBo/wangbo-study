# Sometimes a class needs to provide methods that work without being tied to any particular object.
# We have already come across one such method.
# The new method creates a new Song object but is not itself associated with a particualr song.
# Class methods are distinguished from instance methods by their definition.
# For example:
=begin
class Example
  def instance_method
  end
  def Example.class_method
  end
end
=end

$LOAD_PATH << '.'
require 'eg_3_29'

class SongList
  MAX_TIME = 5 * 60
  def SongList.is_too_long(song)
    return song.duration > MAX_TIME
  end
end

=begin
song1 = Song2.new("Bicylops", "Fleck", 260)
puts SongList.is_too_long(song1)
song2 = Song2.new("The Calling", "Santana", 468)
puts SongList.is_too_long(song2)
=end

