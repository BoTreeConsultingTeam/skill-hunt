FactoryGirl.define do 
  factory :database_category, parent: :category do
    name 'Database'
  end  

  factory :framework_category, parent: :category do
    name 'Framework'
  end
end