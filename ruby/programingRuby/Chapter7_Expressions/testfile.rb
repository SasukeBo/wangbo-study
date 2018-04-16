class Song
  def initialize(name)
    @name = name
  end
  def name
    @name
  end
  def name=(name)
    @name = name
  end
end

song = Song.new("Sasuke")
puts song.name
song.name = "wangbo"
puts song.name
