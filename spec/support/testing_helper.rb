module TestingHelper

  # Returns a string containing the line items from an order
  def line_items_string( order )
    text = String.new
    order.line_items.each do |line_item|
      text << "#{line_item.quantity} x #{line_item.product.name}\n"
    end
    text
  end

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