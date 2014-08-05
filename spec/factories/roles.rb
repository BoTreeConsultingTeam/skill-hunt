FactoryGirl.define do
  factory :role_admin, parent: :role do
    name "administrator"
  end

  factory :role_end_user, parent: :role do
    name "end_user"
  end

  factory :role_company_representative, parent: :role do
    name "company_representative"
  end
end