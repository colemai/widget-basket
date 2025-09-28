require 'spec_helper'
require_relative '../lib/product'
require_relative '../lib/catalog'
require_relative '../lib/basket'
require_relative '../lib/delivery_calculator'
require_relative '../lib/offer_calculator'

RSpec.describe Basket do
  let(:catalog) do
    Catalog.new([
                  Product.new(code: 'R01', name: 'Red Widget', price: 32.95),
                  Product.new(code: 'G01', name: 'Green Widget', price: 24.95),
                  Product.new(code: 'B01', name: 'Blue Widget', price: 7.95)
                ])
  end

  let(:delivery_calculator) do
    DeliveryCalculator.new([
                             { threshold: 90, cost: 0.0 },
                             { threshold: 50, cost: 2.95 },
                             { threshold: 0, cost: 4.95 }
                           ])
  end

  let(:offers) { [BuyOneGetSecondHalfPrice.new('R01')] }

  subject(:basket) { Basket.new(catalog: catalog, delivery_calculator: delivery_calculator, offer_calculators: offers) }

  context 'example baskets' do
    it 'calculates B01, G01 = $37.85' do
      basket.add('B01')
      basket.add('G01')
      expect(basket.total).to eq(37.85)
    end

    it 'calculates R01, R01 = $54.37' do
      basket.add('R01')
      basket.add('R01')
      expect(basket.total).to eq(54.37)
    end

    it 'calculates R01, G01 = $60.85' do
      basket.add('R01')
      basket.add('G01')
      expect(basket.total).to eq(60.85)
    end

    it 'calculates B01, B01, R01, R01, R01 = $98.27' do
      basket.add('B01')
      basket.add('B01')
      basket.add('R01')
      basket.add('R01')
      basket.add('R01')
      expect(basket.total).to eq(98.27)
    end
  end

  context 'edge cases' do
    it 'returns 0.0 for an empty basket' do
      expect(basket.total).to eq(0.0)
    end

    it 'raises an error for an unknown product code' do
      expect { basket.add('ZZZ') }.to raise_error(ArgumentError, /Unknown product code/)
    end

    it 'handles a basket with only one discounted product (no pair, no discount)' do
      basket.add('R01')
      # subtotal = 32.95, delivery = 4.95, no discount
      expect(basket.total).to eq(37.90)
    end

    it 'applies multiple offers correctly if more than one rule is provided' do
      offers = [
        BuyOneGetSecondHalfPrice.new('R01'),
        BuyOneGetSecondHalfPrice.new('G01')
      ]
      multi_offer_basket = Basket.new(
        catalog: catalog,
        delivery_calculator: delivery_calculator,
        offer_calculators: offers
      )

      multi_offer_basket.add('R01')
      multi_offer_basket.add('R01')
      multi_offer_basket.add('G01')
      multi_offer_basket.add('G01')

      # Correct calculation:
      # R01 discount: $32.95 * 0.5 = $16.475 → $16.48 (rounded)
      # G01 discount: $24.95 * 0.5 = $12.475 → $12.48 (rounded)
      # Total discount: $16.48 + $12.48 = $28.96
      # Subtotal: ($32.95 * 2) + ($24.95 * 2) = $115.80
      # Subtotal after discount: $115.80 - $28.96 = $86.84
      # Delivery: $2.95 (since $86.84 is ≥ $50 but < $90)
      # Total: $86.84 + $2.95 = $89.79
      expect(multi_offer_basket.total).to eq(89.79)
    end
  end
end
