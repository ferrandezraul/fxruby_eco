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
      t.belongs_to :line_item, index: true
      t.belongs_to :order, index: true
      t.timestamps null: false
    end

    create_table :customers, force: true do |t|
      t.string :name
      t.string :address
      t.string :nif
      t.string :customer_type
      t.belongs_to :order, index: true
      t.belongs_to :line_item, index: true
      t.timestamps null: false
    end

    create_table :orders, force: true do |t|
      t.date :date
      t.belongs_to :customer, index: true
      t.timestamps null: false
    end

    create_table :line_items do |t|
      t.belongs_to :order, index: true
      t.integer :quantity
      t.decimal :weight, precision: 2, scale: 2
      t.timestamps null: false
    end

  end
end