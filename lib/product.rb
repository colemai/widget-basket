require "bigdecimal"
require "bigdecimal/util"

class Product
  attr_reader :code, :name, :price

  def initialize(code:, name:, price:)
    @code = code
    @name = name
    @price = price.to_d # store as BigDecimal for precision
  end
end
