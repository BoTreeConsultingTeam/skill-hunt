class User < ActiveRecord::Base
  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i
  VALID_PASSWORD_REGEX = /((?=.*\d.*)(?=.*[A-Z].*)(?=.*[!#@\$\*%&\?].*)(?=.*[a-z].*)).{8,20}/

  validates_presence_of :first_name , message: "is required"
  validates_presence_of :last_name  , message: "is required"
  validates_presence_of :gender     , message: "must be selected"  
  validates_inclusion_of :gender, in: %w( M F ), message: "must be M or F"

  validates :email , presence: true,
                     uniqueness: true,
                     format: { with: VALID_EMAIL_REGEX }

  validates_presence_of :password  , message: "is required"
  validates_length_of   :password  , minimum: 8, message: "should be more than 8 characters" 
  validates_length_of   :password  , maximum: 20, message: "should be less than 20 characters"
  validates_format_of   :password  , with: VALID_PASSWORD_REGEX , message: "should have atleast 1 capital letter, 1 special symbol and 1 number"
  validates_presence_of :country_id , message: "must be selected"
end 
