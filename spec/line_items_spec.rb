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
	  	@order.line_items.create( :quantity => 1,
		  						  :weight => 0,
		  						  :product => @product,
		  						  :order => @order )

	    expect( LineItem.count ).to eq(1)
	    expect( Product.count ).to eq(1)
	    expect( @order.line_items.count ).to eq(1)

	    # This is not executed!!
	    # can not call each on an association!!
	    @order.line_items.each do |line_item|
	    	expect( line_item.product.name ).to eq("Product test") 
	    end
	    
	    @product2 = Product.create!( :name => "Product2 test", 
						 :price_type => Product::PriceType::POR_UNIDAD,
						 :price => 5,
						 :tax_percentage => 4 )

	    line_item2 = @order.line_items.create( :quantity => 2,
		  							:weight => 0,
		  							:product => @product,
		  							:order => @order )

	    expect( @order.line_items.count ).to eq(2)

	    text = String.new
	    @order.line_items.each do |line_item|
	    	text << "#{line_item.quantity} x #{line_item.product.name}\n"
	    end

	    expect( text ).to eq("1 x Product test\n2 x Product test\n") # This is a bug!!
	end

end