require "spec_helper"

describe LineItem do
  before do
    # Do something before any single test
    delete_all_records
  end

  it "is deleted when the order is deleted without deleting the product" do
    @soca = create(:soca)
    @pigat = create(:product, :name => "Pigat", :price_type => Product::PriceType::POR_UNIDAD, :price => 5, :tax_percentage => 4 )

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

  it "might be a root line item that contains subitems" do
    @raul = create(:customer)
    @raul_order = Order.create!( :date => Time.now, :customer => @raul )

    items = Array.new
    lote = create(:lote_de_pan) 
    lote.children.each do |subproduct|
        items << LineItem.new( :order => @raul_order,
                               :product => subproduct,
                               :quantity => 1,
                               :weight => 2 )
    end

    parent_item = @raul_order.line_items.create!( :quantity => 1, :weight => 0, :product => lote )
    parent_item.subitems << items    

    expect( @raul_order.line_items.count ).to eq(3)
    expect( LineItem.count ).to eq(3) # Saved to database
    expect( LineItem.all.roots.count ).to eq(1) # Saved to database

    expect( @raul_order.line_items.roots.count ).to eq(1)

    copy_of_parent = @raul_order.line_items.roots.first
    expect( copy_of_parent.subitems.count).to eq(2)

    @raul_order.save
    expect(parent_item.total).to eq(@raul_order.total)
  end
end