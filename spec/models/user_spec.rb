require 'spec_helper'
require 'shared_context'

describe User do
  include_context 'initialize_common_objects'

  let(:user) { User.new }
  let!(:errors) { user.save; user.errors }

  it { should respond_to(:first_name) }
  it { should respond_to(:last_name) }
  it { should respond_to(:gender) }
  it { should respond_to(:email) }
  it { should respond_to(:password) }
  it { should respond_to(:blocked) }  
  it { should respond_to(:country_id) }

  context "#first_name" do
    it "cannot be blank" do
      expect(errors[:first_name]).to_not be_empty
    end  

    it "when blank shows user-friendly message" do
      expect(errors[:first_name]).to include("is required")
    end
  end

  context "#last_name" do
    it "cannot be blank" do 
      expect(user.errors[:last_name]).to_not be_empty
    end

    it "when blank shows user-friendly message" do
      expect(user.errors[:last_name]).to include("is required")
    end
  end

  context "#gender" do
    it "cannot be blank" do 
      expect(errors[:gender]).to_not be_empty
    end

    it "when not selected shows user-friendly message" do
      expect(errors[:gender]).to include("must be selected")
    end

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
    it "email cannot be blank " do
      user.save   
      expect(user.errors[:email]).to_not be_empty
    end

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
    it "cannot be blank" do      
      expect(errors[:password]).to_not be_empty
    end

    it "when blank shows custom message " do      
      expect(errors[:password]).to include("is required")
    end

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
    it "cannot be blank" do    
      expect(errors[:country_id]).to_not be_empty
    end

    it "when not selected shows user-friendly message" do   
      expect(errors[:country_id]).to include("must be selected")
    end
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
    it "returns false when user does not have any role" do
      expect(user.is_administrator?).to be false
    end

    it "returns true when user is assigned administrator role" do
      user.role = admin_user_role
      expect(user.is_administrator?).to be true
    end

    it "returns false when user is not assigned administrator role" do
      user.role = end_user_role
      expect(user.is_administrator?).to be false
    end
  end

  context "#is_end_user?", t: true do
    it "returns false when user does not have any role" do
      expect(user.is_end_user?).to be false
    end

    it "returns true when user is assigned administrator role" do
      user.role = end_user_role
      expect(user.is_end_user?).to be true
    end

    it "returns false when user is not assigned administrator role" do
      user.role = admin_user_role
      expect(user.is_end_user?).to be false
    end
  end

  context "#is_company_representative" do
      it "returns false when user does not have any role" do
      expect(user.is_company_representative?).to be false
    end

    it "returns true when user is assigned administrator role" do
      user.role = company_representative_role
      expect(user.is_company_representative?).to be true
    end

    it "returns false when user is not assigned administrator role" do
      user.role = admin_user_role
      expect(user.is_company_representative?).to be false
    end
  end
end