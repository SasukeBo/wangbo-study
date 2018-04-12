$LOAD_PATH << '.'
require 'Song.rb'

class KaraokeSong < Song
  def initialize(name, artist, duration, lyrics)
    super(name, artist, duration)
    @lyrics = lyrics
  end
  def to_s
    "KS: #@name--#@artist (#@duration) [#@lyrics]"
  end
end

song = KaraokeSong.new("My Way", "Sinatra", 225, "And now, the...")
puts song.to_s
