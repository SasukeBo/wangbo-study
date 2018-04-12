$LOAD_PATH << '.'
require 'eg_3_28.rb'

class Song2 < Song
=begin
  def duration=(new_duration)
    @duration = new_duration
  end
=end
  #Again, Ruby provides a shortcut for creating these simple attribute-setting methods.
  attr_writer :duration
end
=begin
song = Song2.new("good", "Fleck", 20)
puts song.duration
song.duration = 257
puts song.duration
=end
