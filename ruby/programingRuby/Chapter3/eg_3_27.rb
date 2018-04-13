$LOAD_PATH << '.'
require 'Song.rb'

class KaraokeSong < Song
  # Format ourselves as a string by appending
  # our lyrics to our parent's #to_s value
  def initialize(name, artist, duration, lyrics)
    super(name, artist, duration)
    @lyrics = lyrics
  end
  def to_s
    super + "[#@lyrics]"#调用并传参给父类同名方法
  end
end
song = KaraokeSong.new("My Way", "Sinatra", 225, "And now, the...")
puts song.to_s
#所有的类都有一个祖先类叫Object，它的方法适用于所有的类对象
