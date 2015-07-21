#require "spec_helper"

require "product"

describe Product do
	before do
		# Do something before any single test
		delete_all_records
	end

	it "updates taxes and total price into the database when we change its raw price" do
    # uses Factories defined in factories.rb
    @soca = create(:soca)

    @raul = create(:customer)

    @raul_order = Order.create!( :date => Time.now, :customer => @raul )

		price_soca = @soca.price

		new_price = price_soca + 1

		@soca.update( :price => new_price )

		new_taxes = new_price * @soca.tax_percentage / 100
		new_total = new_taxes + new_price

		expect( @soca.total ).to eq(new_total)
		expect( @soca.taxes ).to eq(new_taxes)
	end

	it "is not destroyed from database if product is contained in an order" do
    # uses Factories defined in factories.rb
    @soca = create(:soca)
    @pigat = create(:pigat)

    @raul = create(:customer)

    @raul_order = Order.create!( :date => Time.now, :customer => @raul )

		@raul_order.line_items.create!( :quantity => 1, :weight => 0, :product => @soca )

		expect( Product.count).to eq(2)

		@soca.destroy
		expect( Product.count).to eq(2)

		text = all_orders_from_database_to_string
    expect( text ).to eq("1 x Soca\n")	

	  expect( @soca.is_outdated? ).to eq(true) 
	end

	it "is destroyed from database if product is not contained in an order yet" do
    # uses Factories defined in factories.rb
    @soca = create(:soca)
    @pigat = create(:pigat)

    @raul = create(:customer)

    @raul_order = Order.create!( :date => Time.now, :customer => @raul )

		@raul_order.line_items.create!( :quantity => 1, :weight => 0, :product => @soca )
		expect( Product.count).to eq(2)

		@pigat.destroy
		expect( Product.count).to eq(1)

		text = all_orders_from_database_to_string
    	expect( text ).to eq("1 x Soca\n")	
	end

	it "might contain subproducts children but their prices are ignored" do
    # uses Factories defined in factories.rb
    @soca = create(:soca)
    @pigat = create(:pigat)

    @raul = create(:customer)

    @raul_order = Order.create!( :date => Time.now, :customer => @raul )

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

	it "might be a child of several parent products" do
    # uses Factories defined in factories.rb
    @soca = create(:soca)
    @pigat = create(:pigat)

    @raul = create(:customer)

    @raul_order = Order.create!( :date => Time.now, :customer => @raul )

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
    # uses Factories defined in factories.rb
    @soca = create(:soca)
    @pigat = create(:pigat)

    @raul = create(:customer)

    @raul_order = Order.create!( :date => Time.now, :customer => @raul )

    @lote = create(:lote)

    expect(@lote.has_subproducts?).to eq(false)
    
    @lote.children << @soca
    @lote.children << @pigat

    expect(@lote.has_subproducts?).to eq(true)
    expect(@soca.has_subproducts?).to eq(false)

    lote_item = @raul_order.line_items.create!( :quantity => 1, :weight => 0, :product => @lote )

    subitems = Array.new
    @lote.children.each do |subproduct|
      # Order has to be given
    	subitems << LineItem.new( :quantity => 3, :product => subproduct, :order => @raul_order )
    end

    lote_item.subitems << subitems
    lote_item.save!    

    expect( lote_item.has_subitems? ).to eq( true )

    ## Now check things
    expect( @raul_order.line_items.count ).to eq( 3 )
    
    expect( line_items_string( @raul_order) ).to eq( "1 x Lote de 5 Kilos\n3 x Soca\n3 x Pigat\n" )
  end

end