class Catalog
  def initialize(products)
    @products = products.to_h { |p| [p.code, p] }
  end

  def find(code)
    @products.fetch(code) { raise ArgumentError, "Unknown product code: #{code}" }
  end
end
