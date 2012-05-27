class Array
  def items_following(test)
    index = self.index { |item| test === item }
    first = index + 1
    yield self[first..-1]
  end
end
