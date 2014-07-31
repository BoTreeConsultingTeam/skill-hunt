require 'spec_helper'
require 'shared_examples'

describe Skill do
	let (:skill){ Skill.new }
	
	it { should respond_to(:skill_name)}
	it { should respond_to(:skill_desc)}

	context "#skill_name" do 
    let!(:errors) { skill.save; skill.errors }

		it "cannot be blank" do
      expect(errors).to_not be_empty
    end 
    
    it "when blank shows user-friendly message" do
      expect(errors[:skill_name]).to include("is required")
    end

    it "contains maximum 30 characters" do
      skill.skill_name = 'a'*31
      skill.save
      expect(errors[:skill_name]).to include "must be less than 30 characters"
    end

  end

  context "#skill_desc" do 
  	let!(:errors) { skill.save; skill.errors }

  	it "cannot be blank" do
  		expect(errors).to_not be_empty
  	end 

    it "when blank shows user-friendly message" do
      expect(errors[:skill_desc]).to include "is required"
    end

    it "contains minimum 10 characters", test: true do
      skip
    end

    it "contains maximum 50 characters" do
      skip
    end

  end

  it "must belong to Category" do
    skip
  end
end
