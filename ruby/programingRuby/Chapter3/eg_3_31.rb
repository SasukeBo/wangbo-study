# Class variables names start with two "at" signs.
# Class variables must be initialized before they are used.

class Song
  @@plays = 0
  def initialize(name, artist, duration)
    @name = name
    @artist = artist
    @duration = duration
    @plays = 0
  end
  def play
    @plays += 1
    @@plays += 1
    "This song: #@plays plays. Total #@@plays plays."
  end
end

=begin
s1 = Song.new("Song1", "Artist1", 234)
s2 = Song.new("Song2", "Artist2", 345)
puts s1.play
puts s2.play
puts s1.play
puts s1.play
=end
# class variables的值可以在所有该类实例化的变量中使用，也就是共用一个变量
