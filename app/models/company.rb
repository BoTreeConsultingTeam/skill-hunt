class Company < ActiveRecord::Base
  validates_presence_of :company_name, message: "is required"  
end
