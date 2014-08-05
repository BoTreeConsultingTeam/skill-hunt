class Role < ActiveRecord::Base
	validates_presence_of :name, message: "is required"
end
