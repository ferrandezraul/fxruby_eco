class LineItem < ActiveRecord::Base
	belongs_to :order
	has_one :product
	has_one :customer, through: :order
end