class Role < ActiveRecord::Base
	validates_presence_of :role_name, message: "is required"
end
