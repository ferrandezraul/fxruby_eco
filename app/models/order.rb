class Order < ActiveRecord::Base
	belongs_to :customer, foreign_key: "customer_id"
  	#has_many :line_items
end