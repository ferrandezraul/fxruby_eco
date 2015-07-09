require "spec_helper"

describe LineItem do
	before do
        # Do something before any single test
        delete_all_records

        # uses Factories defined in factories.rb
        @soca = create(:soca)
        @pigat = create( :product, :name => "Pigat", :price_type => Product::PriceType::POR_UNIDAD, :price => 5, :tax_percentage => 4 )

        @raul = create(:customer)
        @carmen = create(:customer, :name => 'Carmen', :address => 'Riudaura', :nif => '23238768Y')

        @raul_order = Order.create!( :date => Time.now, :customer => @raul )
        @carmen_order = Order.create!( :date => Time.now, :customer => @carmen )
	end

end