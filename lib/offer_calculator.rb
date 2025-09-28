class OfferCalculator
  def apply(products)
    0 # default: no discount
  end
end

class BuyOneGetSecondHalfPrice < OfferCalculator
  def initialize(product_code)
    @product_code = product_code
  end

  def apply(products)
    items = products.select { |p| p.code == @product_code }
    return 0 if items.empty?

    pairs = items.count / 2
    (items.first.price * 0.5) * pairs
  end
end
