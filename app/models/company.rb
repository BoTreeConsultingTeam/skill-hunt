class Company < ActiveRecord::Base
  validates_presence_of :company_name, message: "is required"  

  def as_json(options=nil)
    options ||= {}
    
    unless options[:only].present?
      options[:only] = %w(id company_name)
    end
    
    super(options)
  end
end
