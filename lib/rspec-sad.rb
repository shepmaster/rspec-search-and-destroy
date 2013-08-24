require 'rspec-search-and-destroy/version'

require 'rspec-search-and-destroy/order_formatter'
require 'rspec-search-and-destroy/location_source'
require 'rspec-search-and-destroy/reorder_and_filter'

module RSpecSearchAndDestroy
  def self.configure(config)
    config.add_formatter(OrderFormatter)

    source = LocationSource.new
    if source.enabled?
      ordering = ReorderAndFilter.new(source)
      config.order_examples(&ordering.block)
    end
  end
end
