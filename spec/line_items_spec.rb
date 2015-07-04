require "spec_helper"

require 'line_item'
require 'order'
require 'customer'

describe LineItem do
	before do
		# Do something before any single test
		Product.delete_all
		LineItem.delete_all
		Customer.delete_all
		Order.delete_all

		@product = Product.create!( :name => "Product test", 
																:price_type => Product::PriceType::POR_UNIDAD,
																:price => 2.5,
																:tax_percentage => 4 )

		@customer = Customer.create!( :name => "Customer test", 
									  :address => "What ever",
									  :nif => "xxxxxxx",
									  :customer_type => Customer::Type::CLIENTE )

		@order = Order.create!( :date => Time.now, :customer => @customer )
	end

 	it "is created and added to an order" do
 		expect( Order.count ).to eq(1)

 		###############################################################
    ## Add first line item to order with a product 
    ###############################################################
  	@order.line_items.create!( :quantity => 1,
	  						  :weight => 0,
	  						  :product => @product )

    expect( LineItem.count ).to eq(1)
    expect( Product.count ).to eq(1)
    expect( @order.line_items.count ).to eq(1)

    @order.line_items.each do |line_item|
    	expect( line_item.product.name ).to eq("Product test") 
    end

    ###############################################################
    ## Add second line item to order with diferent product 
    ###############################################################
    product2 = Product.create!( :name => "Product2 test", 
					 :price_type => Product::PriceType::POR_UNIDAD,
					 :price => 5,
					 :tax_percentage => 4 )

    @order.line_items.create!( :quantity => 2,
	  							:weight => 0,
	  							:product => product2 )

    expect( @order.line_items.count ).to eq(2)

    text = String.new
    @order.line_items.each do |line_item|
    	text << "#{line_item.quantity} x #{line_item.product.name}\n"
    end

    expect( text ).to eq("1 x Product test\n2 x Product2 test\n")

    ###############################################################
    ## Create second order  
    ###############################################################
    order2 = Order.create!( :date => Time.now, :customer => @customer )
    expect( Order.count ).to eq(2)

    expect( order2.line_items.count ).to eq(0)
    expect( @order.line_items.count ).to eq(2)

    ###############################################################
    ## Add line items to second order with same products from first order 
    ###############################################################
    order2.line_items.create!( :quantity => 2,
	  						  :weight => 0,
	  						  :product => @product )

    order2.line_items.create!( :quantity => 1,
	  						  :weight => 0,
	  						  :product => product2 )

    expect( LineItem.count ).to eq(4)
    expect( Product.count ).to eq(2)
    expect( @order.line_items.count ).to eq(2)
    expect( order2.line_items.count ).to eq(2)

    text = String.new
		order2.line_items.each do |line_item|
			text << "#{line_item.quantity} x #{line_item.product.name}\n"
		end

		expect( text ).to eq("2 x Product test\n1 x Product2 test\n")

		text = String.new
		@order.line_items.each do |line_item|
			text << "#{line_item.quantity} x #{line_item.product.name}\n"
		end

		expect( text ).to eq("1 x Product test\n2 x Product2 test\n")

		###############################################################
    ## Órder and line items were writen in database, 
    ## and now they can be read
    ###############################################################
    text = String.new
    Order.find_each do |order|
	    order.line_items.each do |line_item|
	    	text << "#{line_item.quantity} x #{line_item.product.name}\n"
	    end
	  end

    expect( text ).to eq("1 x Product test\n2 x Product2 test\n2 x Product test\n1 x Product2 test\n")	   
    
    ###############################################################
    ## Deleting an order should remove it from database
    ###############################################################
    @order.destroy!

    expect( Order.count ).to eq(1)

    text = String.new
    Order.find_each do |order|
	    order.line_items.each do |line_item|
	    	text << "#{line_item.quantity} x #{line_item.product.name}\n"
	    end
	  end

    expect( text ).to eq("2 x Product test\n1 x Product2 test\n")	

    expect( LineItem.count ).to eq(2)
    expect( Product.count ).to eq(2)
    expect( order2.line_items.count ).to eq(2)

    ###############################################################
    ## Deleting a product is not possible
    ###############################################################
   #  product2.delete

   #  text = String.new
   #  Order.find_each do |order|
	  #   order.line_items.each do |line_item|
	  #   	# This would crash
	  #   	text << "#{line_item.quantity} x #{line_item.product.name}\n"
	  #   end
	  # end

	  # expect( text ).to eq("1 x Product test\n2 x Product2 test\n2 x Product test\n1 x Product2 test\n")

	  #expect( LineItem.count ).to eq(2)
    #expect( Product.count ).to eq(2)
    #expect( order2.line_items.count ).to eq(2)
	end

end