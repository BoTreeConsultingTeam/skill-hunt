FactoryGirl.define do
  factory :role do
    name 'Role Name'
  end

  factory :user do
    first_name 'TestFirstName'
    last_name 'TestLastName'
    gender 'M'
    email 'test_email@example.com'
    password 'Test1$aaaaaa'
    association :country
  end

  factory :category do
    name 'Category Name'
  end

  factory :company do
    name 'Company Name'
  end

  factory :country do
    name 'Country Name'
  end

  factory :skill do
    name 'Skill Name'
    desc 'Skill Description'
    category
  end
end
