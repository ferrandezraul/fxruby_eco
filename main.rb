#---
# Excerpted from "FXRuby: Create Lean and Mean GUIs with Ruby",
# published by The Pragmatic Bookshelf.
# Copyrights apply to this code. It may not be used to create training material, 
# courses, books, articles, and the like. Contact us if you are in doubt.
# We make no guarantees that this code is fit for any purpose. 
# Visit http://www.pragmaticprogrammer.com/titles/fxruby for more book information.
#---

# add current dir to LOAD_PATH 
$LOAD_PATH.unshift '.'
$LOAD_PATH.unshift './app/models/'
$LOAD_PATH.unshift './app/views/'

require 'fox16'
require 'active_record'
require 'sqlite3'
require 'yaml'
require 'logger'
require 'csv'

require 'product' 
require 'customer'
require 'products_view'
require 'customers_view'

include Fox

class EcocityAdmin < FXMainWindow

  def initialize(app)
    super(app, "Ecocity Admin", :width => 600, :height => 400)

    $APPLOG = Logger.new('app.log', 'monthly') 

    setup_database_conection

    add_menu_bar

    load_sample_data

    tabbook = FXTabBook.new(self, :opts => LAYOUT_FILL)

    FXTabItem.new(tabbook, "Products") 
    ProductsView.new( tabbook, Product.all )

    FXTabItem.new(tabbook, "Customers") 
    CustomersView.new( tabbook, Customer.all )

    FXTabItem.new(tabbook, "Invoices") 
    FXVerticalFrame.new(tabbook, :opts => FRAME_RAISED|LAYOUT_FILL)

    self.connect(SEL_CLOSE, method(:on_close))
  end

  def on_close(sender, sel, event)
    $APPLOG.debug "Closing .."
    puts "Closing .."
    exit
  end

  def setup_database_conection
    ActiveRecord::Base.logger = Logger.new('database.log')
    configuration = YAML::load(IO.read("#{Dir.pwd}/db/config.yml"))
    ActiveRecord::Base.establish_connection(configuration['development'])
  end  

  def load_sample_data
    sample_product = Product.find_by( :name => 'Soca' )

    if sample_product == nil
      $APPLOG.debug "Creating Soca product ..."
      puts "Creating Soca product ..."

      Product.create!( :name => 'Soca',
                       :price => 3.50 )
    end

    sample_customer = Customer.find_by( :name => 'Raul' )

    if sample_customer == nil
      $APPLOG.debug "Creating user raul ..."
      puts "Creating user raul ..."

      Customer.create!( :name => 'Raul',
                        :address => 'Skalitzer Str. 59, Berlin',
                        :nif => '77xxx678-A',
                        :customer_type => Customer::Type::COOPERATIVA )
    end
  end

  def add_menu_bar
    menu_bar = FXMenuBar.new(self, :opts => LAYOUT_SIDE_TOP|LAYOUT_FILL_X)
    export_menu_pane = FXMenuPane.new(self)
    import_menu_pane = FXMenuPane.new(self)

    export_products_command = FXMenuCommand.new(export_menu_pane, "Export Products as CSV")
    export_products_command.connect(SEL_COMMAND) do
      export_products_as_csv
    end

    export_customers_command = FXMenuCommand.new(export_menu_pane, "Export Customers as CSV")
    export_customers_command.connect(SEL_COMMAND) do
      export_customers_as_csv
    end

    import_products_command = FXMenuCommand.new(import_menu_pane, "Import Products as CSV")
    import_products_command.connect(SEL_COMMAND) do
      import_products_as_csv
    end

    import_customers_command = FXMenuCommand.new(import_menu_pane, "Import Customers as CSV")
    import_customers_command.connect(SEL_COMMAND) do
      import_customers_as_csv
    end

    FXMenuTitle.new(menu_bar, "Export", :popupMenu => export_menu_pane)
  end

  def export_products_as_csv
    CSV.open("db/products.csv", "wb") do |csv|
      csv << Product.attribute_names
      Product.all.each do |product|
        csv << product.attributes.values
      end
    end
  end

  def export_customers_as_csv
    CSV.open("db/customers.csv", "wb") do |csv|
      csv << Customer.attribute_names
      Customer.all.each do |customer|
        csv << customer.attributes.values
      end
    end
  end

  def import_products_as_csv
    # TODO
  end

  def import_customers_as_csv
    # TODO
  end

  def create
    super
    show(PLACEMENT_SCREEN)
  end
end

if __FILE__ == $0  
  FXApp.new do |app|
    EcocityAdmin.new(app)
    app.create
    app.run
  end
end
