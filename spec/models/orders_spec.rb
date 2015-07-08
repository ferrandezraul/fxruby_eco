require "spec_helper"

require "order"

describe Order do
  before do
    # Do something before any single test
    delete_all_records

    # uses Factories defined in factories.rb
    @soca = create(:soca)
    @pigat = create(:pigat )

    @raul = create(:customer)
    @carmen = create(:customer, :name => 'Carmen', :address => 'Riudaura', :nif => '23238768Y')

    @raul_order = Order.create!( :date => Time.now, :customer => @raul )
    @carmen_order = Order.create!( :date => Time.now, :customer => @carmen )
  end

  it "created and saved to database" do
    @raul_order.line_items.create!( :quantity => 1, :weight => 0, :product => @soca )

    expect( Order.count ).to eq(2)
    expect( LineItem.count ).to eq(1)
    expect( Product.count ).to eq(2)

    expect( @raul_order.line_items.count ).to eq(1)
    expect( @raul_order.line_items.first.product.name ).to eq("Soca") 
  end

  it "is deleted from database, deleting their line items but not their products" do
    @raul_order.line_items.create!( :quantity => 1, :weight => 0, :product => @soca )
    
    expect( Order.count ).to eq(2)
    expect( LineItem.count ).to eq(1)
    expect( Product.count ).to eq(2)

    @carmen_order.line_items.create!( :quantity => 2, :weight => 0, :product => @soca )
    @carmen_order.line_items.create!( :quantity => 1, :weight => 0, :product => @pigat )

    expect( LineItem.count ).to eq(3)

    @raul_order.destroy!

    expect( Order.count ).to eq(1)
    expect( LineItem.count ).to eq(2)
    expect( Product.count ).to eq(2)

    text = all_orders_from_database_to_string

    expect( text ).to eq("2 x Soca\n1 x Pigat\n") 
    expect( @carmen_order.line_items.count ).to eq(2)
  end

end