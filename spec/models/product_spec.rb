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

	it "updates taxes and total price into the database when we change its raw price" do
		expect( Product.count).to eq(2)

		price_soca = @soca.price

		new_price = price_soca + 1

		@soca.update( :price => new_price )

		new_taxes = new_price * @soca.tax_percentage / 100
		new_total = new_taxes + new_price

		expect( @soca.total ).to eq(new_total)
		expect( @soca.taxes ).to eq(new_taxes)
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

	it "might contain subproducts" do
		lote = Product.create!( :name => "Lote de 5 kilos", :price_type => Product::PriceType::POR_UNIDAD, :price => 20, :tax_percentage => 10 )

		salchichas = Product.create!( :name => "Salchichas", :price_type => Product::PriceType::POR_UNIDAD, :price => 5, :tax_percentage => 10 )

		lomo = Product.create!( :name => "Lomo", :price_type => Product::PriceType::POR_UNIDAD, :price => 6, :tax_percentage => 10 )

		lote.children << salchichas
		lote.children << lomo

		expect( lote.root? ).to eq( true )
		expect( lomo.root? ).to eq( false )

		expect( lote.has_subproducts? ).to eq( true )
		expect( lote.price ).to eq( 20 )

		expected_taxes = 20 * 10 / 100
		expect( lote.taxes ).to eq( expected_taxes )
		expect( lote.tax_percentage ).to eq( 10 )
		expect( lote.total ).to eq( expected_taxes + 20 )
	end

	it "might be a child of several parent products" do
		expect(Product.count).to eq(2)
		lote = Product.create!( :name => "Lote de 5 kilos", 
			:price_type => Product::PriceType::POR_UNIDAD, 
			:price => 20, 
			:tax_percentage => 10 )

		lote2 = Product.create!( :name => "Lote de 2.5 kilos", 
			:price_type => Product::PriceType::POR_UNIDAD, 
			:price => 10, 
			:tax_percentage => 10 )

		expect(Product.count).to eq(4)

		salchichas = Product.create!( :name => "Salchichas", 
			:price_type => Product::PriceType::POR_UNIDAD, 
			:price => 5, 
			:tax_percentage => 10 )

		lomo = Product.create!( :name => "Lomo", 
			:price_type => Product::PriceType::POR_UNIDAD, 
			:price => 6, 
			:tax_percentage => 10 )

		expect(Product.count).to eq(6)

		lote.children << salchichas
		lote2.children << salchichas
		lote2.children << lomo

		# call save not needed
		expect( Product.find_by(:name => 'Lote de 5 kilos').children.count ).to eq(1)
		expect( Product.find_by(:name => 'Lote de 2.5 kilos').children.count ).to eq(2)

		expect( lote.root? ).to eq( true )
		expect( lote2.root? ).to eq( true )

		expect( lote.has_subproducts? ).to eq( true )
		expect( lote2.has_subproducts? ).to eq( true )
	end

end