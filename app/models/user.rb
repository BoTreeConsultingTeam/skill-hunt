class User < ActiveRecord::Base
  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i
  VALID_PASSWORD_REGEX = /((?=.*\d.*)(?=.*[A-Z].*)(?=.*[!#@\$\*%&\?].*)(?=.*[a-z].*)).{8,20}/

  validates_presence_of  :first_name , message: "is required"
  validates_presence_of  :last_name  , message: "is required"

  validate :validate_gender
  validate :validate_email
  validate :validate_password
  validate :validate_country

  has_one :user_role
  has_one :role, through: :user_role

  has_many :user_skills
  has_many :skills, through: :user_skills

  after_create :generate_authentication_token

  def validate_gender
    if gender.present?
      errors.add(:gender, 'must be M or F') unless ['M','F'].include?(gender)
    else
      errors.add(:gender, 'must be selected')
    end
  end

  def validate_email
    if email.present?
      if email.match(VALID_EMAIL_REGEX)
        if new_record?
          errors.add(:email, 'has already been taken') if User.exists?(email: email)
        else
          errors.add(:email, 'email cannot be changed once assigned') if email_changed?
        end
      else
        errors.add(:email, 'not valid') 
      end
    else
      errors.add(:email, 'is required')
    end
  end

  def validate_password
    if password.present?
      errors.add(:password, 'should be more than 8 characters') unless password.length > 8
      errors.add(:password, 'should be less than 20 characters') unless password.length < 20
      errors.add(:password, 'should have atleast 1 capital letter, 1 special symbol and 1 number') unless password.match(VALID_PASSWORD_REGEX)
    else
      errors.add(:password, 'is required')
    end
  end

  def validate_country
      errors.add(:country_id, 'must be selected') unless country_id.present?
      errors.add(:country_id, 'must be india') unless (country_id == Country.find_by(country_name: 'India').id)
  end
  
  def is_administrator?
    return false unless role.present?
    role.role_name == "administrator"
  end

  def as_json(options=nil)
    options ||= {}
    
    unless options[:only].present?
      options[:only] = %w(id first_name last_name gender email blocked)
    end
    
    super(options)
  end

  def generate_authentication_token
    begin
      token = SecureRandom.hex
    end while User.exists?(authentication_token: token)
    token
  end 
end  