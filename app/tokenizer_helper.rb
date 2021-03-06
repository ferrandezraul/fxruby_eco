require 'product'
require 'line_item'
require 'customer'
require 'order'

module TokenizerHelper

  # Returns a string containing the line items from an order
  def line_items_string( order )
    text = String.new
    order.line_items.each do |line_item|
      text << line_item_string( line_item )    
    end
    text
  end

  # Returns a string containing the line items from an order
  def line_item_string( item )
    text = String.new
    if item.root?
      text << "#{item.quantity} x #{item.product.name}\n"
      if item.has_subitems?
        item.subitems.each do |subitem|
          text << "#{subitem.quantity} x #{subitem.product.name}\n"
        end
      end
    end      
    text
  end

  def product_to_s(product)
    text = "#{product.name}"
    #if product.has_subproducts?
    if product.children.count > 0
      text << "\n"
      num_children = product.children.count
      product.children.each_with_index do |c, index|
        text << "#{'  ' * 2}#{c.name}"
        text << "\n" if index < num_children  # Do not add break line if last element
      end      
    end

    text
  end

end