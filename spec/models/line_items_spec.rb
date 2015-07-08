require "spec_helper"

describe LineItem do
	before do
		# Do something before any single test
		delete_all_records

		# uses Factories defined in factories.rb
		@soca = create(:soca)
		@pigat = create( :product, :name => "Pigat", :price_type => Product::PriceType::POR_UNIDAD, :price => 5, :tax_percentage => 4 )

		@raul = create(:customer)
		@carmen = create(:customer, :name => 'Carmen', :address => 'Riudaura', :nif => '23238768Y')

		@raul_order = Order.create!( :date => Time.now, :customer => @raul )
		@carmen_order = Order.create!( :date => Time.now, :customer => @carmen )
	end

    it "is added to an order" do |variable|
        @raul_order.line_items.create!( :quantity => 1, :weight => 0, :product => @soca )
        @raul_order.line_items.create!( :quantity => 2, :weight => 0, :product => @pigat )

        expect( @carmen_order.line_items.count ).to eq(0)
        expect( @raul_order.line_items.count ).to eq(2)

        text = line_items_string( @raul_order )

        expect( text ).to eq("1 x Soca\n2 x Pigat\n")
    end

    it "is deleted when the order is deleted without deleting the product" do 
        @raul_order.line_items.create!( :quantity => 1, :weight => 0, :product => @soca )

        expect( Order.count ).to eq(2)
        expect( LineItem.count ).to eq(1)
        expect( Product.count ).to eq(2)

        @raul_order.destroy # Calling delete would not work

        expect( Order.count ).to eq(1)
        expect( LineItem.count ).to eq(0)
        expect( Product.count ).to eq(2)
    end    

 	it "is created and added to an order" do
        @raul_order.line_items.create!( :quantity => 1, :weight => 0, :product => @soca )
        @raul_order.line_items.create!( :quantity => 2, :weight => 0, :product => @pigat )

        @carmen_order.line_items.create!( :quantity => 2, :weight => 0, :product => @soca )
        @carmen_order.line_items.create!( :quantity => 1, :weight => 0, :product => @pigat )

        expect( LineItem.count ).to eq(4)
        expect( Product.count ).to eq(2)

        expect( @raul_order.line_items.count ).to eq(2)
        expect( @carmen_order.line_items.count ).to eq(2)

        text = line_items_string( @carmen_order )
		expect( text ).to eq("2 x Soca\n1 x Pigat\n")

		text = line_items_string( @raul_order )
		expect( text ).to eq("1 x Soca\n2 x Pigat\n")

        text = all_orders_from_database_to_string

        expect( text ).to eq("1 x Soca\n2 x Pigat\n2 x Soca\n1 x Pigat\n")	           
	end

end