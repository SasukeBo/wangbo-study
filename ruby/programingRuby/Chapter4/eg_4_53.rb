# start_button = Button.new("Start")
# pause_button = Button.new("Pause")

class StartButton < Button
  def initialize
    super("Start")
  end
  def button_pressed
    puts "Start button pressed"
  end
end

start_button = StartButton.new
puts start_button.button_pressed
