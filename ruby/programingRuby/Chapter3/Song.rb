class Song
  def initialize(name, artist, duration) #initialize method is a special method ,it work when you new
    @name     = name
    @artist   = artist
    @duration = duration
  end

  def to_s    #override the to_s method
    "Song: #@name--#@artist (#@duration)"
  end
end
