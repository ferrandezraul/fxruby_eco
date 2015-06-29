require "spec_helper"

require 'customer'
require "customers_csv_builder"

describe CustomersCSVBuilder do
	before do
		# Do something before any single test
		Customer.delete_all
	end

	it "creates an array with customers without creating them on database" do
		customers = CustomersCSVBuilder::build_from_csv("db/customers.csv")

		expect(Customer.count).to eq(0)
		expect(customers.count).to eq(4)
	end

 	it "creates customers in the database from a csv file" do
	  	expect( Customer.count ).to eq(0)

	  	CustomersCSVBuilder::create_from_csv( "db/customers.csv" )

	    expect( Customer.count ).to eq(4)
	end

	it "deletes existing customers in database when creating from csv" do
		Customer.create!( :name => "What ever", 
						  :address => "What ever",
						  :nif => "xxxxxxx",
						  :customer_type => Customer::Type::CLIENTE )

	  	expect( Customer.count ).to eq(1)

	  	CustomersCSVBuilder::create_from_csv( "db/customers.csv" )

	    expect( Customer.count ).to eq(4)
	end

	it "exports customers to a csv file" do
	  	expect( Customer.count ).to eq(0)

	  	CustomersCSVBuilder::create_from_csv( "db/customers.csv" )
	  	CustomersCSVBuilder::export_csv( "db/customers_test.csv" )

	    expect( File.exist?("db/customers_test.csv") ).to eq(true)
	    expect( CSV.read("db/customers_test.csv").count ).to eq(5) # 5 lines in csv (headers counted)
	end

end