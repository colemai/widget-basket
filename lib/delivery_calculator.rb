class DeliveryCalculator
  def initialize(rules)
    # rules = [ { threshold: 90, cost: 0 }, { threshold: 50, cost: 2.95 }, { threshold: 0, cost: 4.95 } ]
    @rules = rules.sort_by { |r| -r[:threshold] }
  end

  def apply(subtotal:)
    rule = @rules.find { |r| subtotal >= r[:threshold] }
    rule ? rule[:cost] : 0
  end
end
