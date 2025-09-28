class Catalog
  def initialize(products)
    @products = products.index_by(&:code)
  end

  def find(code)
    @products.fetch(code) { raise ArgumentError, "Unknown product code: #{code}" }
  end
end