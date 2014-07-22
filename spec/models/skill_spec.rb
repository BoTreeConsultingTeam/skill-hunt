require 'spec_helper'

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
  end
  context "#skill_desc" do 
  	let!(:errors) { skill.save; skill.errors }

  	it "cannot be blank" do
  		expect(errors).to_not be_empty
  	end 
  end
end
