require 'spec_helper'

describe User do
  let!(:india) { Country.create(country_name: 'India') }
  let(:user) { User.new }

  it { should respond_to(:first_name) }
  it { should respond_to(:last_name) }
  it { should respond_to(:gender) }
  it { should respond_to(:email) }
  it { should respond_to(:password) }
  it { should respond_to(:blocked) }  
  it { should respond_to(:country_id) }
  it { should respond_to(:role) }

  shared_examples "check" do | attribute,message |
    let!(:errors) { user.save; user.errors }

    it "cannot be blank" do
      expect(errors["#{attribute}"]).to_not be_empty
    end

    it "when blank shows user-friendly message" do
      expect(errors["#{attribute}"]).to include("#{message}")
    end  
  end

  context "#first_name" do

    message = "is required"
    it_should_behave_like "check", [:first_name, message]
=begin
    let!(:errors) { user.save; user.errors }

    it "when blank shows user-friendly message" do
      expect(errors[:first_name]).to include("is required")
    end
=end
  end
  
  context "#last_name" do
    message = "is required"
    it_should_behave_like "check", [:last_name, message]
=begin
    let!(:errors) { user.save; user.errors }

    it "when blank shows user-friendly message" do
      expect(user.errors[:last_name]).to include("is required")
    end
=end
  end


  context "#gender" do
    message = "must be selected"
    it_should_behave_like "check", [:gender, message]
=begin
    let!(:errors) { user.save; user.errors }

    it "when not selected shows user-friendly message" do
      expect(errors[:gender]).to include("must be selected")
    end
=end
    let!(:errors) { user.save; user.errors }
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
    message = "is required"
    it_should_behave_like "check", [:email, message]

    it "email already taken" do
      user = User.new(first_name:"Ankur",
                      last_name: "Vyas", 
                      gender: "M",
                      email: "ankurvy1@gmail.com",
                      password: "Ankur12@12",
                      blocked: "false",
                      country_id: india.id
                     )
      user.save
      expect(user.errors).to be_empty
      
      other_user = User.new(first_name:"Ambika",
                      last_name: "Bhatt", 
                      gender: "F",
                      email: "ankurvy1@gmail.com",
                      password: "Ankur12@",
                      blocked: "false",
                      country_id: india.id
                      )
      
      other_user.save      
      expect(other_user.errors).to_not be_empty
    end


    it "must be in proper format" do
      user.email = "abc@.com"
      user.save
      expect(user.errors[:email]).to_not be_empty
    end
  end

  context "#password" do
    message = "is required"

    it_should_behave_like "check", [:password,message]

    let!(:errors) { user.save; user.errors }


    context "is invalid" do
      it "when have less than 8 characters" do
        user.password = "aaaa"
        user.save
        expect(errors[:password]).to include("should be more than 8 characters")
      end

      it "when have more than 20 characters" do
        user.password = "a"*21
        user.save
        expect(errors[:password]).to include("should be less than 20 characters")
      end 

      it "when does not contain 1 captial letter, special symbol or number" do
        user.password = "abc"
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
    message = "must be selected"
    it_should_behave_like "check", [:country_id, message]
=begin
    let!(:errors) { user.save; user.errors}

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
    it "returns false when user does not have any role" do
      expect(user.is_administrator?).to be false
    end

    it "returns true when user is assigned administrator role" do
      skip
    end

    it "returns false when user is not assigned administrator role" do
      skip
    end
  end

  context "#is_end_user?" do
    it "returns false when when user does not have any role" do
      skip
    end

    it "returns true when user is assigned end_user role" do
    skip
    end

    it "returns false when user is not assigned end_user role" do
      skip
    end
  end


  context "#is_company_representative?" do
    it "returns false when when user does not have any role" do
      skip
    end

    it "returns true when user is assigned company_representative role" do
    skip
    end

    it "returns false when user is not assigned company_representative role" do
      skip
    end
  end

  context "#is_signed_in?" do
    it "returns true when a user is signed in" do
      skip
    end

    it "returns false when a user is not signed in" do
      skip
    end
  end

  context "#is_active?" do
    it "returns true when user is active" do
      skip  
    end

    it "returns false when user is blocked" do
      skip  
    end
  end

  context "#is_having_skill(skill)?" do
    it "returns false when user have not selected desired skill" do
      skip
    end

    it "returns true when user have selected desired skill" do
      skip
    end
  end

  context "#from_India?" do
    it "returns true when user is from India" do
      skip
    end

    it "returns false when user is not from India" do
      skip
    end
  end

end