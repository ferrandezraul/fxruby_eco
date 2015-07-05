require "spec_helper"

require "order"

describe Order do
  before do
    # Do something before any single test
    delete_all_records

    # uses Factories defined in factories.rb
    @soca = create(:product)
    @pigat = create(:product, :name => "Pigat", :price_type => Product::PriceType::POR_UNIDAD, :price => 5, :tax_percentage => 4 )

    @raul = create(:customer)
    @carmen = create(:customer, :name => 'Carmen', :address => 'Riudaura', :nif => '23238768Y')

    @raul_order = Order.create!( :date => Time.now, :customer => @raul )
    @carmen_order = Order.create!( :date => Time.now, :customer => @carmen )

    @raul_order.line_items.create!( :quantity => 1, :weight => 0, :product => @soca )
  end

  it "created and saved to database" do
    expect( Order.count ).to eq(2)
    expect( LineItem.count ).to eq(1)
    expect( Product.count ).to eq(2)

    expect( @raul_order.line_items.count ).to eq(1)
    expect( @raul_order.line_items.first.product.name ).to eq("Soca") 
  end

end