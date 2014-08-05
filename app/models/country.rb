class Country < ActiveRecord::Base
	validates_presence_of :name, message: "is required"
  validates_uniqueness_of :name, message: 'already exists'

  has_many :users

  def as_json(options=nil)
    options ||= {}
    
    unless options[:only].present?
      options[:only] = %w(id name)
    end
    
    super(options)
  end
end
