class VU
  include Comparable
  attr :volume
  def initialize(volume)
    @volume = volume
  end
  def inspect
    '#' * @volume
  end
  # Support for ranges
  def <=>(other)
    self.volume <=> other.volume
  end
  def succ
    raise(IndexError, "Volume too big") if @volume >= 9
    VU.new(@volume.succ)
  end
end

# 因为VU类实现了succ和<=>方法，因此可以作为区间
medium_volume = VU.new(4)..VU.new(7)
puts medium_volume.to_a
puts medium_volume.include?(VU.new(3))
