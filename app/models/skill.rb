class Skill < ActiveRecord::Base
	validates_presence_of :skill_name, message: "is required"
  	validates_presence_of :skill_desc 
end
