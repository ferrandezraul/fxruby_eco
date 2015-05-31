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

require 'product' 
require 'products_view'

include Fox

class EcocityAdmin < FXMainWindow

  def initialize(app)
    super(app, "Ecocity Admin", :width => 600, :height => 400)

    $APPLOG = Logger.new('app.log', 'monthly') 

    setup_database_conection

    add_menu_bar

    load_sample_data

    add_products_view    

    self.connect(SEL_CLOSE, method(:on_close))
  end

  def on_close(sender, sel, event)
    $APPLOG.debug "Storing data .."
    puts "Storing data .."
    store_data
    exit
  end

  def setup_database_conection
    ActiveRecord::Base.logger = Logger.new('database.log')
    configuration = YAML::load(IO.read("#{Dir.pwd}/db/config.yml"))
    ActiveRecord::Base.establish_connection(configuration['development'])
  end  

  def add_menu_bar
    # Add menu
  end

  def load_sample_data
    Product.create( :name => 'Soca', :price => 3.50 )
    Product.create( :name => 'Socas', :price => 3.50 )
    Product.create( :name => 'Socag', :price => 3.50 )
    Product.create( :name => 'Socaj', :price => 3.50 )
    Product.create( :name => 'Socak', :price => 3.50 )
    Product.create( :name => 'Socal', :price => 3.50 )
    Product.create( :name => 'Socan', :price => 3.50 )
    Product.create( :name => 'Socab', :price => 3.50 )
  end

  def add_products_view
    ProductsView.new( self, Product.all )
  end
  
  def store_data
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
