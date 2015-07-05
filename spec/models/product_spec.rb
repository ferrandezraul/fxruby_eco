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

		@raul_order.line_items.create!( :quantity => 1, :weight => 0, :product => @soca )
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

end