require "spec_helper"
require_relative "../lib/product"
require_relative "../lib/catalog"
require_relative "../lib/basket"
require_relative "../lib/delivery_calculator"
require_relative "../lib/offer_calculator"

RSpec.describe Basket do
  let(:catalog) do
    Catalog.new([
      Product.new(code: "R01", name: "Red Widget", price: 32.95),
      Product.new(code: "G01", name: "Green Widget", price: 24.95),
      Product.new(code: "B01", name: "Blue Widget", price: 7.95)
    ])
  end

  let(:delivery_calculator) do
    DeliveryCalculator.new([
      { threshold: 90, cost: 0.0 },
      { threshold: 50, cost: 2.95 },
      { threshold: 0, cost: 4.95 }
    ])
  end

  let(:offers) { [BuyOneGetSecondHalfPrice.new("R01")] }

  subject(:basket) { Basket.new(catalog: catalog, delivery_calculator: delivery_calculator, offer_calculators: offers) }

  context "example baskets" do
    it "calculates B01, G01 = $37.85" do
      basket.add("B01")
      basket.add("G01")
      expect(basket.total).to eq(37.85)
    end

    it "calculates R01, R01 = $54.37" do
      basket.add("R01")
      basket.add("R01")
      expect(basket.total).to eq(54.37)
    end

    it "calculates R01, G01 = $60.85" do
      basket.add("R01")
      basket.add("G01")
      expect(basket.total).to eq(60.85)
    end

    it "calculates B01, B01, R01, R01, R01 = $98.27" do
      basket.add("B01")
      basket.add("B01")
      basket.add("R01")
      basket.add("R01")
      basket.add("R01")
      expect(basket.total).to eq(98.27)
    end
  end
end
