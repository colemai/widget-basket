require "bigdecimal"
require "bigdecimal/util"

class DeliveryCalculator
  def initialize(rules)
    # Normalize rules so costs and thresholds are BigDecimals
    @rules = rules.map do |r|
      {
        threshold: r[:threshold].to_d,
        cost: r[:cost].to_d
      }
    end.sort_by { |r| -r[:threshold] }
  end

  def apply(subtotal:)
    rule = @rules.find { |r| subtotal >= r[:threshold] }
    rule ? rule[:cost] : 0.to_d
  end
end
