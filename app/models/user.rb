class User < ActiveRecord::Base
  #constants
  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i
  VALID_PASSWORD_REGEX = /(?=.*\d.*)(?=.*[A-Z].*)(?=.*[!#@\$%&\?].*)(?=.*[a-z].*).{8,20}/

  validates_presence_of :first_name , message: "is required"
  validates_presence_of :last_name  , message: "is required"
  validates_presence_of :gender     , message: "must be selected"  
  validates_inclusion_of :gender    , in: %w( M F ), message: "must be M or F"

  validates :email , presence: true,
                     uniqueness: true,
                     format: { with: VALID_EMAIL_REGEX }

  VALID_PASSWORD_REGEX = /((?=.*\d.*)(?=.*[A-Z].*)(?=.*[!#\@\$%&\?].*)(?=.*[a-z].*)).{8,20}/
  validates_presence_of :password   , message: "is required"
  validates :password, length: { minimum:8,maximum:20 },
                       format: { with: VALID_PASSWORD_REGEX }
  validates_presence_of :country_id , message: "must be selected"
end 
