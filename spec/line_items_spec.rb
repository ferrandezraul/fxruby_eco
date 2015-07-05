require "spec_helper"

require 'line_item'
require 'order'
require 'customer'
require 'factories'
require 'testing_helper'

describe LineItem do
	before do
		# Do something before any single test
		delete_all_records

		# uses Factories defined in factories.rb
		@soca = create(:product)
		@raul = create(:customer)
		@raul_order = Order.create!( :date => Time.now, :customer => @raul )

		@raul_order.line_items.create!( :quantity => 1,
	  						                    :weight => 0,
	  						                    :product => @soca )
	end

 	it "is created and added to an order" do
 		expect( Order.count ).to eq(1)
    expect( LineItem.count ).to eq(1)
    expect( Product.count ).to eq(1)
    expect( @raul_order.line_items.count ).to eq(1)

    @raul_order.line_items.each do |line_item|
    	expect( line_item.product.name ).to eq("Soca") 
    end

    ###############################################################
    ## Add second line item to order with diferent product 
    ###############################################################
    pigat = create( :product, :name => "Pigat", 
					 :price_type => Product::PriceType::POR_UNIDAD,
					 :price => 5,
					 :tax_percentage => 4 )

    @raul_order.line_items.create!( :quantity => 2,
	  							:weight => 0,
	  							:product => pigat )

    expect( @raul_order.line_items.count ).to eq(2)

    #text = String.new
    #@raul_order.line_items.each do |line_item|
   # 	text << "#{line_item.quantity} x #{line_item.product.name}\n"
   # end

    text = line_items_string( @raul_order )

    expect( text ).to eq("1 x Soca\n2 x Pigat\n")

    ###############################################################
    ## Create second order  
    ###############################################################
    order2 = Order.create!( :date => Time.now, :customer => @raul )
    expect( Order.count ).to eq(2)

    expect( order2.line_items.count ).to eq(0)
    expect( @raul_order.line_items.count ).to eq(2)

    ###############################################################
    ## Add line items to second order with same products from first order 
    ###############################################################
    order2.line_items.create!( :quantity => 2,
	  						  :weight => 0,
	  						  :product => @soca )

    order2.line_items.create!( :quantity => 1,
	  						  :weight => 0,
	  						  :product => pigat )

    expect( LineItem.count ).to eq(4)
    expect( Product.count ).to eq(2)
    expect( @raul_order.line_items.count ).to eq(2)
    expect( order2.line_items.count ).to eq(2)

    text = line_items_string( order2 )

		expect( text ).to eq("2 x Soca\n1 x Pigat\n")

		text = line_items_string( @raul_order )

		expect( text ).to eq("1 x Soca\n2 x Pigat\n")

		###############################################################
    ## Órder and line items were writen in database, 
    ## and now they can be read
    ###############################################################
    text = all_orders_from_database_to_string

    expect( text ).to eq("1 x Soca\n2 x Pigat\n2 x Soca\n1 x Pigat\n")	   
    
    ###############################################################
    ## Deleting an order should remove it from database
    ###############################################################
    @raul_order.destroy!

    expect( Order.count ).to eq(1)

    text = all_orders_from_database_to_string

    expect( text ).to eq("2 x Soca\n1 x Pigat\n")	

    expect( LineItem.count ).to eq(2)
    expect( Product.count ).to eq(2)
    expect( order2.line_items.count ).to eq(2)

    ###############################################################
    ## Deleting a product is not possible
    ###############################################################
    #  pigat.delete

    #  text = all_orders_from_database_to_string
	  # expect( text ).to eq("1 x Soca\n2 x Pigat\n2 x Soca\n1 x Pigat\n")

	  #expect( LineItem.count ).to eq(2)
    #expect( Product.count ).to eq(2)
    #expect( order2.line_items.count ).to eq(2)
	end

end