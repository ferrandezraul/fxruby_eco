require "spec_helper"

describe LineItem do
  before do
    # Do something before any single test
    delete_all_records
  end

  it "is deleted when the order is deleted without deleting the product" do
    @soca = create(:soca)
    @pigat = create( :product, :name => "Pigat", :price_type => Product::PriceType::POR_UNIDAD, :price => 5, :tax_percentage => 4 )

    @raul = create(:customer)

    @raul_order = Order.create!( :date => Time.now, :customer => @raul )

    @raul_order.line_items.create!( :quantity => 1, :weight => 0, :product => @soca )

    expect( Order.count ).to eq(1)
    expect( LineItem.count ).to eq(1)
    expect( Product.count ).to eq(2)

    @raul_order.destroy # Calling delete would not work

    expect( Order.count ).to eq(0)
    expect( LineItem.count ).to eq(0)
    expect( Product.count ).to eq(2)
  end 

end