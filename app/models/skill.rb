class Skill < ActiveRecord::Base
  validates_presence_of :desc, message: 'is required'
  validates_presence_of :category_id, message: 'is required'
  validates :name, uniqueness: true

  validate :validate_name

  belongs_to :category

  has_many :user_skills
  has_many :users, through: :user_skills

  def validate_name
    if name.present?
      errors.add(:name, 'must be less than 30 characters') if name.length > 30
    else
      errors.add(:name, 'is required')
    end
  end  

  def as_json(options=nil)
    options ||= {}
    
    unless options[:only].present?
      options[:only] = %w(name desc category_id)
    end
    
    super(options)
  end
end
