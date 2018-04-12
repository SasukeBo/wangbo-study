$LOAD_PATH << '.'
require 'eg_3_29'

class Song30 < Song2
  def duration_in_minutes
    @duration/60.0    #force floating point
  end
  def duration_in_minutes=(new_duration)
    @duration = (new_duration*60).to_i
  end
end
=begin
song = Song30.new("Bicylops", "Fleck", 260)
puts song.duration_in_minutes
song.duration_in_minutes = 4.2
puts song.duration
=end
