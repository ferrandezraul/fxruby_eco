class LineItem < ActiveRecord::Base
	belongs_to :order
	has_one :product
end