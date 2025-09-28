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
    return 0.0 if @items.empty? # edge case: empty basket

    subtotal = @items.sum(&:price)
    discount = @offer_calculators.sum { |offer| offer.apply(@items) }
    subtotal_after_discount = subtotal - discount
    delivery = @delivery_calculator.apply(subtotal: subtotal_after_discount)

    total = subtotal_after_discount + delivery

    # Banker's rounding (round half to even), 2 decimal places
    total.round(2, BigDecimal::ROUND_HALF_EVEN).to_f
  end
end
