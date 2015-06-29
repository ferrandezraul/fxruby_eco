require "spec_helper"

require "product"

describe Product do
	before do
		# Do something before any single test
		Product.delete_all
	end

 	it "has a name" do
	  	product = Product.new( :name => "Andi" )
	    expect( product.name ).to eq("Andi")
	end

	it "has a price type" do
		product = Product.new( :price_type => Product::PriceType::POR_KILO )
		expect( product.price_type ).to eq( Product::PriceType::POR_KILO )
	end

	it "saves data into the database with create function" do
		expect( Product.count).to eq(0)

		Product.create!( :name => "What ever", 
						 :price_type => Product::PriceType::POR_KILO,
						 :price => 2.5,
						 :tax_percentage => 4 )

		expect( Product.count).to eq(1)
	end

end