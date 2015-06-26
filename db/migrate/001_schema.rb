# For creatring new associations or new tables,
# edit this file and never touch db/schema.rb
# db/schema.rb is automatically updated when you run rake db:migrate

class Schema < ActiveRecord::Migration
  def change
    create_table :products, force: true do |t|
      t.string :name
      t.decimal :price, precision: 2, scale: 2
      t.decimal :weight, precision: 2, scale: 2
      t.decimal :taxes, precision: 2, scale: 2 
    end

    create_table :customers, force: true do |t|
      t.string :name
      t.string :address
      t.string :nif
      t.string :customer_type
    end

    create_table :orders do |t|
      t.datetime :date
      t.belongs_to  :customer
    end

    create_table :line_items do |t|
      t.integer :quantity
      t.decimal :weight, precision: 2, scale: 2
      t.has_one :product # has one product
      t.belongs_to :order   # belongs to an order
    end

  end
end