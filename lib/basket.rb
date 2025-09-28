class Basket
  def initialize(catalog:, delivery_calculator:, offer_calculators: [])
    @catalog = catalog
    @delivery_calculator = delivery_calculator
    @offer_calculators = offer_calculators
    @items = []
  end

  def add(code)
    @items << @catalog.find(code)
  end

  def total
    subtotal = @items.sum(&:price)
    discount = @offer_calculators.sum { |offer| offer.apply(@items) }
    subtotal_after_discount = subtotal - discount
    delivery = @delivery_calculator.apply(subtotal: subtotal_after_discount)
    (subtotal_after_discount + delivery).round(2)
  end
end
