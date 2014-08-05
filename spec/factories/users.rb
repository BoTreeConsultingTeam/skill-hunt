FactoryGirl.define do
  factory :admin_user, parent: :user do
    first_name 'Admin'
    last_name 'User'
    gender 'M'
    email 'admin@example.com'
    password 'A1$aaabba'
    country
  end

  factory :end_user, parent: :user do
    first_name 'End'
    last_name 'User'
    gender 'M'
    email 'end_user@example.com'
    password 'A1$aaabba'
    country
  end
end