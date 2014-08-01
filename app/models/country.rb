class Country < ActiveRecord::Base
	validates_presence_of :country_name, message: "is required"
  validates_uniqueness_of :country_name, message: 'already exists'

  def as_json(options=nil)
    options ||= {}
    
    unless options[:only].present?
      options[:only] = %w(id country_name)
    end
    
    super(options)
  end
end
