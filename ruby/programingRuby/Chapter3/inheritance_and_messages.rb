$LOAD_PATH << '.'   #告知ruby需要从当前目录中引用文件
require 'Song.rb'

class KaraokeSong < Song  #此处<号类似于Java的extends
  def initialize(name, artist, duration, lyrics)
    super(name, artist, duration)
    @lyrics = lyrics
  end
  def to_s
    super + " #@lyrics"
  end
end

song = KaraokeSong.new("My Way", "Sinatra", 225, "And now, the...")
puts song.to_s

