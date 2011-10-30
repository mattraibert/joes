class Units
  attr_reader :value

  def initialize value
    @value = (value * 1000).to_i
  end

  def self.zero
    @zero ||= Units.new(0)
  end

  def + addend
    Units.new((value + addend.value) / 1000.0)
  end

  def - subtrahend
    Units.new((value - subtrahend.value) / 1000.0)
  end

  def == comparable
    value == comparable.value
  end

  def <=> comparable
    value <=> comparable.value
  end

  def to_s
    (@value / 1000.0).to_s
  end
end
