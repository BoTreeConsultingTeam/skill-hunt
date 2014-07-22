class Country < ActiveRecord::Base
	validates_presence_of :country_name , message: "is required"
end
