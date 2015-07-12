require 'spec_helper'

describe Product do
  before do
    # Do something before any single test
    delete_all_records
  end  

  it "has a name, price, price type and tax percentage" do
    # uses Factories defined in factories.rb
    @pigat = create(:pigat)
    expect( @pigat.name ).to eq("Pigat")
    expect( @pigat.price ).to eq(5)
    expect( @pigat.price_type ).to eq(Product::PriceType::POR_UNIDAD)
    expect( @pigat.tax_percentage ).to eq(4)
  end

  it "saves data into the database with create function" do
    expect( Product.count).to eq(0)

    create( :product, :name => "What ever", :price_type => Product::PriceType::POR_KILO, :price => 2.5, :tax_percentage => 4 )
    expect( Product.count).to eq(1)
  end

  it "doesn't change its price when children are added" do
    @soca = create(:soca)
    @pigat = create(:pigat)
    
    @lote = create(:lote)

    price = @lote.price
      
    @lote.children << @soca
    @lote.children << @pigat

    expect( @lote.price ).to eq(price)
  end

end