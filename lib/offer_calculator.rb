class OfferCalculator
  def apply(_products)
    0 # default: no discount
  end
end

class BuyOneGetSecondHalfPrice < OfferCalculator
  def initialize(product_code)
    @product_code = product_code
  end

  def apply(products)
    items = products.select { |p| p.code == @product_code }
    return 0.to_d if items.empty?

    pairs = items.count / 2
    half_price = (items.first.price * 0.5).round(2, BigDecimal::ROUND_HALF_EVEN)
    half_price * pairs
  end
end
