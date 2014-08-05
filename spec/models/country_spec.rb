require 'spec_helper'

describe Country do
	let(:country) { Country.new }

	it { should respond_to(:name) }

  context "#name" do
    let!(:errors) { country.save; country.errors }

  	it "cannot be blank" do      		
  		expect(errors[:name]).to_not be_empty
  	end
    
  	it "when blank shows user-friendly message" do
  		expect(errors[:name]).to include("is required")
  	end
  end

  it "has list of Companies" do
    skip
  end

  it "has list of Users" do
    skip
  end
end
