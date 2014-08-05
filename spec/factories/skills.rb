FactoryGirl.define do
  factory :ruby_skill, parent: :skill do
    name 'Ruby'
    desc 'Skill Description of Ruby'
    category
  end

  factory :dot_net_skill, parent: :skill do
    name 'Dot Net'
    desc 'Skill Description of Dot Net'
    category
  end

  factory :java_skill, parent: :skill do
    name 'Java'
    desc 'Skill Description of Java'
    category
  end

    factory :python_skill, parent: :skill do
    name 'Python'
    desc 'Skill Description of Python'
    category
  end
end