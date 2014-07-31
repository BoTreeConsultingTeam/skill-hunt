class Skill < ActiveRecord::Base
  validates_presence_of :skill_desc, message: 'is required'
  validates_presence_of :category_id, message: 'is required'
  validates :skill_name, uniqueness: true

  validate :validate_skill_name

  has_one :category

  has_many :user_skills
  has_many :users, through: :user_skills

  def validate_skill_name
    if skill_name.present?
      errors.add(:skill_name, 'must be less than 30 characters') if skill_name.length > 30
    else
      errors.add(:skill_name, 'is required')
    end
  end  

  def as_json(options=nil)
    options ||= {}
    
    unless options[:only].present?
      options[:only] = %w(skill_name skill_desc category_id)
    end
    
    super(options)
  end
end
