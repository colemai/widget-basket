# Widget Basket Toy Repo

This is a small Ruby proof-of-concept for a basket and checkout system. It calculates totals for products, applies delivery charges according to thresholds, and supports special offers. It was written as a coding challenge but structured as if it could evolve into a production system.

## Example Usage (setup.rb)

I've written a little setup.rb to set up the basic entities

`bundle install`

`ruby setup.rb`

## Testing

RSpec tests are included under spec/. They reproduce the acceptance examples from the brief and ensure totals match exactly, including tricky rounding cases. Run them with:

`bundle install`

`bundle exec rspec`

## Design Choices

- DeliveryCalculator and OfferCalculator  
  I was torn between storing delivery rates and special offers in database tables, or instead wiring them in as code. A pure hash/database solution is simpler at first, for this toy app you could simply grab the flat threshold-adjusted rates from a hash, but less flexible for long-term complexity growth. For example, imagine a future scenario with a B2B client in a far-flung country, with a specific time-constrained price contract, variable wholesale rates, deliveries heavy enough to require weight adjustments, and priority tracked shipping. In such cases, a database row alone could maybe capture all the logic, but not in a way that leaves your code and db neat.

  I opted for a hybrid approach for deliveries. Basic thresholds or rates can live in data, which is neat and also easy to update with a database writes rather than a code change and deploy. More complex future logic can be encapsulated in small strategy classes in the private section of the delivery calculator. This avoids spirals of messy conditional code and “frankensteined” systems while allowing future extensibility.

  For special offers, I kept the logic in code only. Offers tend to be fewer in number and more variable in structure, so they don’t map well to a single database table. A clean Ruby class per offer keeps things understandable and testable.

- Rails vs just Ruby  
  In a real life setting I would have used Rails. For this small proof-of-concept, plain Ruby was simpler and clearer.

## Implementation Notes

- Products are simple objects with code, name, and price stored as BigDecimal for precision.
- Catalog maps product codes to product instances.
- Basket takes a catalog, a delivery calculator, and a list of offer calculators. It supports add(code) and total().
- DeliveryCalculator implements threshold-based shipping rules, returning costs as BigDecimal.
- Offers implement a common interface (apply(products)). BuyOneGetSecondHalfPrice is included as an example.
- Totals use banker’s rounding (round half to even) at two decimal places to avoid floating-point drift and match financial expectations.
