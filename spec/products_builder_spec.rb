require "spec_helper"

require 'product'
require "products_builder"

describe ProductsBuilder do
	before do
		# Do something before any single test
	end

	it "creates an array with products without creating them on database" do
		products = ProductsBuilder::build_from_csv("db/products.csv")

		expect(Product.count).to eq(0)
		expect(products.count).to eq(4)
	end

 	it "creates products in the database from a csv file" do
	  	expect( Product.count ).to eq(0)

	  	ProductsBuilder::create_from_csv( "db/products.csv" )

	    expect( Product.count ).to eq(4)
	end

	it "deletes existing products in database when creating from csv" do
		Product.create!( :name => "What ever", 
						 :price_type => Product::PriceType::POR_KILO,
						 :price => 2.5,
						 :tax_percentage => 4 )

	  	expect( Product.count ).to eq(5)

	  	ProductsBuilder::create_from_csv( "db/products.csv" )

	    expect( Product.count ).to eq(4)
	end

end