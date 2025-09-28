#!/usr/bin/env ruby
# Simple demo of the basket

require_relative 'lib/product'
require_relative 'lib/catalog'
require_relative 'lib/basket'
require_relative 'lib/delivery_calculator'
require_relative 'lib/offer_calculator'

products = [
  Product.new(code: 'R01', name: 'Red Widget', price: 32.95),
  Product.new(code: 'G01', name: 'Green Widget', price: 24.95),
  Product.new(code: 'B01', name: 'Blue Widget', price: 7.95)
]

catalog = Catalog.new(products)

delivery_rules = DeliveryCalculator.new([
                                          { threshold: 90, cost: 0.0 },
                                          { threshold: 50, cost: 2.95 },
                                          { threshold: 0, cost: 4.95 }
                                        ])

offers = [BuyOneGetSecondHalfPrice.new('R01')]

basket = Basket.new(catalog: catalog, delivery_calculator: delivery_rules, offer_calculators: offers)

basket.add('B01')
basket.add('G01')

puts "Basket total: $#{basket.total}"
