require "spec_helper"

require "product"

describe Product do
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
	end

 	it "has a name, price, price type and tax percentage" do
	    expect( @pigat.name ).to eq("Pigat")
	    expect( @pigat.price ).to eq(5)
	    expect( @pigat.price_type ).to eq(Product::PriceType::POR_UNIDAD)
	    expect( @pigat.tax_percentage ).to eq(4)
	end

	it "saves data into the database with create function" do
		expect( Product.count).to eq(2)

		create( :product, :name => "What ever", :price_type => Product::PriceType::POR_KILO, :price => 2.5, :tax_percentage => 4 )
		expect( Product.count).to eq(3)
	end

	it "is not destroyed from database if product is contained in an order" do
		@raul_order.line_items.create!( :quantity => 1, :weight => 0, :product => @soca )

		expect( Product.count).to eq(2)

		@soca.destroy
		expect( Product.count).to eq(2)

		text = all_orders_from_database_to_string
    expect( text ).to eq("1 x Soca\n")	

    # TODO but product is marked as out_of_list
    expect( @soca.is_outdated? ).to eq(true) 
	end

	it "is destroyed from database if product is not contained in an order yet" do
		@raul_order.line_items.create!( :quantity => 1, :weight => 0, :product => @soca )

		expect( Product.count).to eq(2)
		other = create( :product, :name => "What ever", :price_type => Product::PriceType::POR_KILO, :price => 2.5, :tax_percentage => 4 )
		expect( Product.count).to eq(3)

		other.destroy
		expect( Product.count).to eq(2)

		text = all_orders_from_database_to_string
    expect( text ).to eq("1 x Soca\n")	
	end

end