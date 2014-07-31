require 'spec_helper'
require 'shared_examples'

describe User do

  let(:user) { User.new }
  let!(:india) { Country.create(country_name: 'India') }

  it { should respond_to(:first_name) }
  it { should respond_to(:last_name) }
  it { should respond_to(:gender) }
  it { should respond_to(:email) }
  it { should respond_to(:password) }
  it { should respond_to(:blocked) }  
  it { should respond_to(:country_id) }

=begin
  shared_examples "check" do |attribute, message|
    let!(:errors) { user.save; user.errors }

    it "cannot be blank" do
      expect(errors["#{attribute}"]).to_not be_empty
    end

    it "when blank shows user-friendly message" do
      expect(errors["#{attribute}"]).to include("#{message}")
    end
  end
=end
  context "#first_name" do

    #let!(:errors) { user.save; user.errors }
    it_should_behave_like "check", [User.new, :first_name, "is required"]
    
=begin 
    it "cannot be blank" do
      expect(errors[:first_name]).to_not be_empty
    end  

    it "when blank shows user-friendly message" do
      expect(errors[:first_name]).to include("is required")
    end
=end
  end

  context "#last_name" do
    #let!(:errors) { user.save; user.errors }
    it_should_behave_like "check", [User.new, :last_name, "is required"]

=begin
    it "cannot be blank" do 
      expect(user.errors[:last_name]).to_not be_empty
    end

    it "when blank shows user-friendly message" do
      expect(user.errors[:last_name]).to include("is required")
    end
=end
  end


  context "#gender" do

    let!(:errors) { user.save; user.errors }
    it_should_behave_like "check", [User.new, :gender, "must be selected"]

=begin
    it "cannot be blank" do 
      expect(errors[:gender]).to_not be_empty
    end

    it "when not selected shows user-friendly message" do
      expect(errors[:gender]).to include("must be selected")
    end
=end

    it "must have only one character" do      
      user.gender= "M" * 1 
      user.save       
      expect(errors[:gender]).to be_empty
    end

    it "must be either F or M" do
      user.gender = "A"
      user.save
      expect(errors[:gender]).to include("must be M or F")
    end
  end

  context "#email" do  
    it_should_behave_like "check", [User.new, :email, "is required"]
=begin
    it "email cannot be blank " do
      user.save   
      expect(user.errors[:email]).to_not be_empty
    end
=end
    it "email already taken" do
      user = User.new(first_name:"Ankur",
                      last_name: "Vyas", 
                      gender: "M",
                      email: "ankurvy1@gmail.com",
                      password: "Ankur12@#",
                      blocked: "false",
                      country_id: india.id
                     )
      user.save
      expect(user.errors).to be_empty
      
      other_user = User.new(first_name:"Ambika",
                      last_name: "Bhatt", 
                      gender: "F",
                      email: "ankurvy1@gmail.com",
                      password: "Ankur12@#",
                      blocked: "false",
                      country_id: india.id
                      )
      
      other_user.save
      expect(other_user.errors[:email]).to include 'has already been taken'
    end

    it "must be in proper format" do
      user.email = "abc@.com"
      user.save
      expect(user.errors[:email]).to_not be_empty
    end
  end

  context "#password" do
    let!(:errors) { user.save; user.errors }
    it_should_behave_like "check", [User.new, :password, "is required"]   
  
=begin
    it "cannot be blank" do      
      expect(errors[:password]).to_not be_empty
    end

    it "when blank shows custom message " do      
      expect(errors[:password]).to include("is required")
    end
=end
    context "is invalid" do
      it "when have less than 8 characters" do
        user.password = "a"*6
        user.save
        expect(errors[:password]).to include("should be more than 8 characters")
      end

      it "when have more than 20 characters" do
        user.password = "a"*21
        user.save
        expect(errors[:password]).to include("should be less than 20 characters")
      end 

      it "when does not contain 1 captial letter, special symbol or number" do
        user.password = "abcdefghi"
        user.save
        expect(errors[:password]).to include("should have atleast 1 capital letter, 1 special symbol and 1 number")        
      end
    end

    context "is valid" do
      it "when have exact 1 captial letter, 1 special symbol and 1 number " do
        user.password = 'Ankurr1t@'
        user.save      
        expect(user.errors[:password]).to be_empty
      end

      it "when have more than 1 captial letter, special symbol or number" do
        user.password = "AAnkur12!@"
        user.save
        expect(user.errors[:password]).to be_empty
      end
    end
  end


  context "#country_id" do
    #let!(:errors) { user.save; user.errors}
    it_should_behave_like "check", [User.new, :country_id, "must be selected"]   
  
=begin
    it "cannot be blank" do    
      expect(errors[:country_id]).to_not be_empty
    end

    it "when not selected shows user-friendly message" do   
      expect(errors[:country_id]).to include("must be selected")
    end
  
=end
  end

  context "#blocked" do
    it "must not be blank" do
      expect(user.blocked).to be false
    end

    it "must be false by default" do
      expect(user.blocked).to be false
    end 

    it "must be true when set to true" do
      user.blocked = true
      expect(user.blocked).to be true
    end   
  end 

  context "#is_administrator?" do

    skip
=begin
    it "returns false when user does not have any role" do
      expect(user.is_administrator?).to be false
    end

    it "returns true when user is assigned administrator role" do
      skip
    end

    it "returns false when user is not assigned administrator role" do
      skip
    end
=end
  end

  context "#is_novice" do
    skip
  end

  context "#is_company_representative" do
    skip
  end

  it "is having skills" do
    skip
  end
end