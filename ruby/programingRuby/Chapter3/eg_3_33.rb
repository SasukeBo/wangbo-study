# Sometimes you want to override the default way in which Ruby creats object.

class MyLogger
  private_class_method :new
  @@logger = nil
  def MyLogger.create
    @@logger = new unless @@logger
    @@logger
  end
end

# puts MyLogger.create.object_id
# puts MyLogger.create.object_id


# The following all define calss methods within class Demo.
class Demo
  def Demo.meth1
    # ...
    puts "this is class method meth1"
  end
  def self.meth2
    # ...
    puts "this is class method meth2"
  end
  class << self
    def meth3
      # ...
      puts "this is class method meth3"
    end
  end
end

=begin
Demo.meth1
Demo.meth2
Demo.meth3
=end
