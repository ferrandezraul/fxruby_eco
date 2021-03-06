require 'product'
require 'line_item'
require 'customer'
require 'order'
require 'tokenizer_helper'

module TestingHelper

  # Returns a string containing the line items from an order
  def all_orders_from_database_to_string
    text = String.new
    Order.find_each do |order|
        text << line_items_string( order )
    end
    text
  end

  def delete_all_records
    Product.delete_all
    LineItem.delete_all
    Customer.delete_all
    Order.delete_all
  end
end