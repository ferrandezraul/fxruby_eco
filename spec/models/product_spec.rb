require "spec_helper"

require "product"

describe Product do
	before do
		# Do something before any single test
		delete_all_records

		# uses Factories defined in factories.rb
		@soca = create(:soca)
		@pigat = create(:pigat)

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

	  expect( @soca.is_outdated? ).to eq(true) 
	end

	it "is destroyed from database if product is not contained in an order yet" do
		@raul_order.line_items.create!( :quantity => 1, :weight => 0, :product => @soca )
		expect( Product.count).to eq(2)

		@pigat.destroy
		expect( Product.count).to eq(1)

		text = all_orders_from_database_to_string
    	expect( text ).to eq("1 x Soca\n")	
	end

	it "might contain subproducts children but their prices are ignored" do
		lote = create(:lote)

		salchichas = Product.create!( :name => "Salchichas", :price_type => Product::PriceType::POR_UNIDAD, :price => 5, :tax_percentage => 10 )

		lomo = Product.create!( :name => "Lomo", :price_type => Product::PriceType::POR_UNIDAD, :price => 6, :tax_percentage => 10 )

		lote.children << salchichas
		lote.children << lomo

		expect( lote.price ).to eq( 40 )

		expected_taxes = 40 * 10 / 100
		expect( lote.taxes ).to eq( expected_taxes )
		expect( lote.tax_percentage ).to eq( 10 )
		expect( lote.total ).to eq( expected_taxes + 40 )
	end

	it "doesn't change its price when children are added" do
	    @lote = create(:lote)
	    price = @lote.price
	    
	    @lote.children << @soca
	    @lote.children << @pigat

	    expect( @lote.price ).to eq(price)
	end

	it "might be a child of several parent products" do
		@lote = create(:lote)

		@lote2 = Product.create!( :name => "Lote de 2.5 kilos", 
			:price_type => Product::PriceType::POR_UNIDAD, 
			:price => 10, 
			:tax_percentage => 10 )

		salchichas = Product.create!( :name => "Salchichas", 
			:price_type => Product::PriceType::POR_UNIDAD, 
			:price => 5, 
			:tax_percentage => 10 )

		lomo = Product.create!( :name => "Lomo", 
			:price_type => Product::PriceType::POR_UNIDAD, 
			:price => 6, 
			:tax_percentage => 10 )

		@lote.children << salchichas
		@lote2.children << salchichas
		@lote2.children << lomo

		# call save not needed
		expect( Product.find_by(:name => 'Lote de 5 Kilos').children.count ).to eq(1)
		expect( Product.find_by(:name => 'Lote de 2.5 kilos').children.count ).to eq(2)
	end

	it "can be a root and have children" do
    @lote = create(:lote)

    expect(@lote.has_subproducts?).to eq(false)
    
    @lote.children << @soca
    @lote.children << @pigat

    expect(@lote.has_subproducts?).to eq(true)
    expect(@soca.has_subproducts?).to eq(false)

    lote_item = @raul_order.line_items.create!( :quantity => 1, :weight => 0, :product => @lote )

    @lote.children.each do |subproduct|
    	lote_item.subitems << LineItem.create!( :quantity => 3, :product => subproduct )
    end
    ## Now check things
    expect( @raul_order.line_items.count ).to eq( 1 )
    
    expect( line_items_string( @raul_order) ).to eq( "1 x Lote de 5 Kilos\n\t3 x Soca\n\t3 x Pigat\n" )

    puts "\n"
    puts @raul_order
    expect( Order.find_by!( :id => @raul_order.id ).to_s).to eq("Test")

    # implement order.to_s
    #expect( @raul_order.to_s ).to eq(  )
  end

end