require 'active_record'

class Product < ActiveRecord::Base
	belongs_to :line_item
	belongs_to :order

	validates :name, presence: true, uniqueness: true
	validates :price, presence: true
	validates :taxes, presence: true
end
