require "spec_helper"

require "product"

describe Product do
	before do
		# Do something before any single test
	end

 	it "has a name" do
	  	product = Product.new( :name => "Andi" )
	    expect( product.name ).to eq("Andi")
	end

	it "has a price type" do
		product = Product.new( :price_type => Product::PriceType::POR_KILO )
		expect( product.price_type ).to eq( Product::PriceType::POR_KILO )
	end

end