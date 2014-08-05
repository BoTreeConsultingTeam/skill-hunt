FactoryGirl.define do
  factory :india_country, parent: :country do
    name 'India'
  end

  factory :america_country, parent: :country do
    name 'America'
  end

  factory :brazil_country, parent: :country do
    name 'Brazil'
  end
end