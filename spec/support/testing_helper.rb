module TestingHelper

  # Returns a string containing the line items from an order
  def line_items_string( order )
    text = String.new
    order.line_items.each do |line_item|
      text << "#{line_item.quantity} x #{line_item.product.name}\n"
    end
    text
  end
end