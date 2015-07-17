require 'tokenizer_helper'

include Fox
include TokenizerHelper

class ProductsTable < FXTable
  attr_reader :current_product

  COLUMN_ID = 0
  COLUMN_NAME = 1
  COLUMN_PRICE_TYPE = 2
  COLUMN_RAW_PRICE = 3
  COLUMN_TAX_PERCENTAGE = 4
  COLUMN_TAXES = 5
  COLUMN_TOTAL = 6
  NUM_COLUMNS = 7
  
  def initialize(parent)
    super(parent, :opts => TABLE_COL_SIZABLE|TABLE_ROW_SIZABLE|LAYOUT_FILL_X|LAYOUT_FILL_Y)

    fill_table(Product.all.where( :outdated => false ) )

    self.connect(SEL_REPLACED, method(:on_cell_changed))
    self.connect(SEL_DOUBLECLICKED, method(:on_cell_double_clicled))
    self.connect(SEL_COMMAND, method(:on_new_selected))
  end

  def fill_table(products)
    setTableSize(0, NUM_COLUMNS)

    columnHeaderMode = LAYOUT_FILL_X
    rowHeaderMode = LAYOUT_FILL_X
    setColumnText(COLUMN_ID, "ID")
    setColumnText(COLUMN_NAME, "NAME")
    setColumnText(COLUMN_PRICE_TYPE, "PRICE TYPE")
    setColumnText(COLUMN_RAW_PRICE, "PRICE WITHOUT TAXES")
    setColumnText(COLUMN_TAX_PERCENTAGE, "IVA %")
    setColumnText(COLUMN_TAXES, "IVA EUR")
    setColumnText(COLUMN_TOTAL, "TOTAL")

    columnHeader.setItemJustify(COLUMN_ID, FXHeaderItem::CENTER_X)
    columnHeader.setItemJustify(COLUMN_NAME, FXHeaderItem::CENTER_X)
    columnHeader.setItemJustify(COLUMN_PRICE_TYPE, FXHeaderItem::CENTER_X)
    columnHeader.setItemJustify(COLUMN_RAW_PRICE, FXHeaderItem::CENTER_X)
    columnHeader.setItemJustify(COLUMN_TAX_PERCENTAGE, FXHeaderItem::CENTER_X)
    columnHeader.setItemJustify(COLUMN_TAXES, FXHeaderItem::CENTER_X)
    columnHeader.setItemJustify(COLUMN_TOTAL, FXHeaderItem::CENTER_X)

    products.each do |product|
      add_product(product)
    end
  end

  def add_product( product )
    num_rows = getNumRows
    appendRows( 1 )
    fill_row( num_rows, product )
  end

  def fill_row( row, product )
    setItemText( row, COLUMN_ID, product.id.to_s )
    setItemText( row, COLUMN_NAME, product_to_s(product) )
    setItemText( row, COLUMN_PRICE_TYPE, product.price_type )
    setItemText( row, COLUMN_RAW_PRICE, "#{ sprintf('%.2f', product.price ) }" )
    setItemText( row, COLUMN_TAX_PERCENTAGE, "#{ sprintf('%.2f', product.tax_percentage ) }" )
    setItemText( row, COLUMN_TAXES, "#{ sprintf('%.2f', product.taxes ) }" )
    setItemText( row, COLUMN_TOTAL, "#{ sprintf('%.2f', product.total ) }" )    
    if product.has_subproducts?
      setRowHeight( row, product.children.count * 50 ) 
    end
  end

  def reset
    clearItems
    @current_product = nil
    fill_table(Product.all.where( :outdated => false ))
  end

  def on_cell_changed(sender, sel, table_pos)
    # table_pos fm = from
    #           to = to
    # Table has changed from cell between fm and to
    # Assume only a cell is changed
    column = table_pos.fm.col
    row = table_pos.fm.row

    product_id = getItemText( row, COLUMN_ID ).to_i
    product = Product.find_by!( :id => getItemText( row, COLUMN_ID ) )

    case column
    when COLUMN_ID
      FXMessageBox.warning( self, MBOX_OK, "Id is not editable", "You can not edit the id!" )
      # Revert id in view
      product = Product.find_by!( :name => getItemText( row, COLUMN_NAME ),
                                  :price => getItemText( row, COLUMN_RAW_PRICE ) )

      setItemText( row, COLUMN_ID, product.id.to_s )
    when COLUMN_NAME
      new_name = getItemText( row, COLUMN_NAME )

      product.update( :name => new_name ) 
      fill_row( row, product )  
    when COLUMN_PRICE_TYPE
      new_type = getItemText( row, COLUMN_PRICE_TYPE )

      if (new_type != Product::PriceType::POR_KILO) && (new_type != Product::PriceType::POR_KILO)
        FXMessageBox.warning( self, MBOX_OK, "Invalid type", 
          "Invalid type!! Use #{Product::PriceType::POR_KILO} or #{Product::PriceType::POR_UNIDAD}" )
        fill_row( row, product )
        return
      end

      product.update( :price_type => new_type ) 
      fill_row( row, product )   
    when COLUMN_RAW_PRICE
      new_price = getItemText( row, COLUMN_RAW_PRICE ).to_f

      product.update( :price => new_price.round(2) ) 
      fill_row( row, product )
    when COLUMN_TAX_PERCENTAGE
      new_taxes = getItemText( row, COLUMN_TAX_PERCENTAGE )

      product.update( :tax_percentage => new_taxes ) 
      fill_row( row, product )
    else
      FXMessageBox.warning( self, MBOX_OK, "You can not edit this column", 
          "You can not edit this column. Only name, price type, price and tax is editable" )
      fill_row( row, product )
    end
  end

  def on_cell_double_clicled( sender, sel, table_pos)
    # nothing
  end

  def on_new_selected( sender, sel, table_pos)
    row = table_pos.row
    @current_product = Product.find_by!( :id => getItemText( row, COLUMN_ID ) ) 
  end

  def create
    super
    show()
  end

end