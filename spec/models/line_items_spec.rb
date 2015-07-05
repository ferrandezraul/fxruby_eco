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
		@pigat = create( :product, :name => "Pigat", :price_type => Product::PriceType::POR_UNIDAD, :price => 5, :tax_percentage => 4 )

		@raul = create(:customer)
		@carmen = create(:customer, :name => 'Carmen', :address => 'Riudaura', :nif => '23238768Y')

		@raul_order = Order.create!( :date => Time.now, :customer => @raul )
		@carmen_order = Order.create!( :date => Time.now, :customer => @carmen )

		@raul_order.line_items.create!( :quantity => 1, :weight => 0, :product => @soca )
	end

 	it "is created and added to an order" do
 		expect( Order.count ).to eq(2)
        expect( LineItem.count ).to eq(1)
        expect( Product.count ).to eq(2)
        expect( @raul_order.line_items.count ).to eq(1)
        expect( @raul_order.line_items.first.product.name ).to eq("Soca") 

        ###############################################################
        ## Add second line item to order with diferent product 
        ###############################################################
        @raul_order.line_items.create!( :quantity => 2,
    	  							:weight => 0,
    	  							:product => @pigat )

        expect( @carmen_order.line_items.count ).to eq(0)
        expect( @raul_order.line_items.count ).to eq(2)

        text = line_items_string( @raul_order )

        expect( text ).to eq("1 x Soca\n2 x Pigat\n")

        ###############################################################
        ## Add line items to second order with same products from first order 
        ###############################################################
        @carmen_order.line_items.create!( :quantity => 2,
    							  						   :weight => 0,
    							  						   :product => @soca )

        @carmen_order.line_items.create!( :quantity => 1,
    	  						  :weight => 0,
    	  						  :product => @pigat )

        expect( LineItem.count ).to eq(4)
        expect( Product.count ).to eq(2)
        expect( @raul_order.line_items.count ).to eq(2)
        expect( @carmen_order.line_items.count ).to eq(2)

        text = line_items_string( @carmen_order )

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
        expect( @carmen_order.line_items.count ).to eq(2)
	end

end