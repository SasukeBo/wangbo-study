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
    super + "[#@lyrics]"
  end
end
song = KaraokeSong.new("My Way", "Sinatra", 225, "And now, the...")
puts song.to_s

