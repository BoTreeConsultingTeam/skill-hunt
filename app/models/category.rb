class Category < ActiveRecord::Base
  validates_presence_of  :name , message: "is required"
  validates :name, uniqueness: true

  def as_json(options=nil)
    options ||= {}
    
    unless options[:only].present?
      options[:only] = %w(name)
    end
    
    super(options)
  end
end
