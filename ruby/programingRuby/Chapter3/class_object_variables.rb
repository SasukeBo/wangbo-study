class Song
  def initialize(name, artist, duration) #initialize method is a special method ,it work when you new
    @name     = name
    @artist   = artist
    @duration = duration
  end
end

song = Song.new("Bicylops", "Fleck", 260)
puts song.inspect
puts song.to_s

class Song2
  def initialize(name, artist, duration) #initialize method is a special method ,it work when you new
    @name     = name
    @artist   = artist
    @duration = duration
  end

  def to_s    #override the to_s method 
    "Song: #@name--#@artist (#@duration)"
  end
end
song = Song2.new("Bicylops", "Fleck", 260)
puts song.to_s

