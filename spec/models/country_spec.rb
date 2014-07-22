require 'spec_helper'

describe Country do
	let(:country) { Country.new }

	it { should respond_to(:country_name) }

  context "#country_name" do
    let!(:errors) { country.save; country.errors }

  	it "cannot be blank" do      		
  		expect(errors.messages[:country_name]).to_not be_empty
  	end
    
  	it "when blank shows user-friendly message" do
  		expect(errors.messages[:country_name]).to include("is required")
  	end
  end
end
