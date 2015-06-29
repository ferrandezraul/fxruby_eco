require 'csv'

class CustomersCSVBuilder

	# Creates customers in database from a csv file
	def self.create_from_csv( file )
		raise Exception.new("#{file} does npot exist!!") if !File.exist?(file)
		
		Customer.destroy_all

	    # TODO (handle errors in csv)
	    CSV.foreach(file, :headers => true) do |csv_row|
	      #puts "Row is #{csv_row}" #puts "Row is #{csv_row.class}" #puts "Row inspect is #{csv_row.inspect}"
	      #puts "Row inspect is #{csv_row.to_hash}"
	      Customer.create!( csv_row.to_hash )
	    end
	end

	# Returns an array of customers from a csv file without modifying database
	def self.build_from_csv( file )
		raise Exception.new("#{file} does npot exist!!") if !File.exist?(file)
		
		customers = Array.new
		
	    CSV.foreach(file, :headers => true) do |csv_row|
	      customers << Customer.new( csv_row.to_hash )
	    end

	    customers
	end

	# Creates a csv file with customer attributes from database
	def self.export_csv( file )
		CSV.open(file, "wb") do |csv|

		# Add headers
        csv << Customer.attribute_names

        # Add customer attributes
        Customer.all.each do |customer|
          csv << customer.attributes.values
        end
      end
	end

end
