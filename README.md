# ActiveRecord::With

Adds WITH to ActiveRecord::Query methods

## Installation

Add this line to your application's Gemfile:

    gem 'active_record-with'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install active_record-with

## Usage

    Order.
      with(regional_sales: Order.select('region', 'sum(amount) as total_sales').group('region')).
      with(top_regions: Order.select("region").from('regional_sales').where("total_sales > (SELECT SUM(total_sales)/10 FROM regional_sales)")).
      select("region", "product", "SUM(quantity) AS product_units", "SUM(amount) AS proudct_sales").
      where("region in (SELECT region from top_regions)").
      group("region, product")

should product SQL like

    WITH regional_sales AS (
            SELECT region, SUM(amount) AS total_sales
            FROM orders
            GROUP BY region
         ), top_regions AS (
            SELECT region
            FROM regional_sales
            WHERE total_sales > (SELECT SUM(total_sales)/10 FROM regional_sales)
         )
    SELECT region,
           product,
           SUM(quantity) AS product_units,
           SUM(amount) AS product_sales
    FROM orders
    WHERE region IN (SELECT region FROM top_regions)
    GROUP BY region, product;

## TODO

Add support for recusion.

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
