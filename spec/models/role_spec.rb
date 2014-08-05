require 'spec_helper'

describe Role do
	let(:role) { Role.new }

	it { should respond_to(:name)}

	context "#name" do
		let!(:errors) { role.save; role.errors }

		it "cannot be blank" do
      expect(errors).to_not be_empty
    end 

    it "when blank shows user-friendly message" do
      expect(errors[:name]).to include("is required")
    end
	end
end
