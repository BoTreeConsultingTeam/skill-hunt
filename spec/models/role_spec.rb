require 'spec_helper'
require 'shared_examples'

describe Role do
	let(:role) { Role.new }

	it { should respond_to(:role_name)}

	context "#role_name" do
    it_should_behave_like "check", [Role.new, :role_name, "is required"]
    
=begin
		let!(:errors) { role.save; role.errors }

		it "cannot be blank" do
      expect(errors).to_not be_empty
    end 

    it "when blank shows user-friendly message" do
      expect(errors[:role_name]).to include("is required")
    end
=end
	end

  it "have zero or many Users" do
    skip
  end
end
