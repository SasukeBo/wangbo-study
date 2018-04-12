class Song
  def initialize(name, artist, duration)
    @name = name
    @artist = artist
    @duration = duration
  end
=begin
  def name
    @name
  end
  def artist
    @artist
  end
  def duration
    @duration
  end
=end
  #还可以这样写
  attr_reader :name, :artist, :duration
  #于上面三个方法功能一样
end
=begin
song = Song.new("Bicylops", "Fleck", 260)
puts song.artist,song.name,song.duration
=end
