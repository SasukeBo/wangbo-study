# start_button = Button.new("Start")
# pause_button = Button.new("Pause")

class StartButton # < Button
=begin
  def initialize
    super("Start")
  end
=end
  def button_pressed
    puts "Start button pressed"
  end
end

start_button = StartButton.new
puts start_button.button_pressed
