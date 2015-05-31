class ProductsView < Fox::FXMatrix
  attr_reader :product
  
  def initialize(parent, products)
    super(parent, :opts => LAYOUT_FILL)    
    @products = products

    table = FXTable.new(self, :opts => LAYOUT_FILL)
    table.setTableSize(@products.count, 2)

    table.setColumnText(0, "Name")
    table.setColumnText(1, "Price")

    table.rowHeaderMode = ~LAYOUT_FIX_WIDTH
    table.columnHeader.setItemJustify(0, FXHeaderItem::CENTER_X)
    table.columnHeader.setItemJustify(1, FXHeaderItem::CENTER_X)

    @products.each_with_index do | product, index |
      table.setItemText( index, 0, product.name )
      table.setItemText( index, 1, product.price )
    end
  end

end