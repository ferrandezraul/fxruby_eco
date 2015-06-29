require "spec_helper"

require 'product'
require "products_builder"

describe ProductsBuilder do
	before do
		# Do something before any single test
	end

 	it "creates products in the database from a csv file" do
	  	expect( Product.count ).to eq(0)

	  	ProductsBuilder::from_csv( "db/products.csv" )

	    expect( Product.count ).to eq(4)
	end

end