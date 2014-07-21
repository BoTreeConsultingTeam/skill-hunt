require 'spec_helper'

describe User do

  let(:user) { User.new }

  it { should respond_to(:first_name) }
  it { should respond_to(:last_name) }
  it { should respond_to(:gender) }
  it { should respond_to(:email) }
  it { should respond_to(:password) }
  it { should respond_to(:blocked) }  
  it { should respond_to(:country_id) }

  context "#first_name" do
    let!(:errors) { user.save; user.errors }

    it "cannot be blank" do
      expect(errors).to_not be_empty
    end  

    it "when blank shows user-friendly message" do
      expect(errors.messages[:first_name]).to include("is required")
    end
  end

  context "#last_name" do
    let!(:errors) { user.save; user.errors }

    it "cannot be blank" do 
      expect(user.errors).to_not be_empty
    end

    it "when blank shows user-friendly message" do
      expect(user.errors.messages[:last_name]).to include("is required")
    end
  end

  context "#gender" do
    let!(:errors) { user.save; user.errors }

    it "cannot be blank" do 
      expect(errors).to_not be_empty
    end

    it "when not selected shows user-friendly message" do
      expect(errors.messages[:gender]).to include("must be selected")
    end


    it "must have only one character" do      
      user.gender= "a" * 1        
      expect(errors.messages[:gender]).to_not be_empty
    end

    it "must be either F or M" do
      user.gender = "A"
      expect(errors.messages[:gender]).to include("must be M or F")
    end

  end

  context "#email", check: true do
    

    it "email cannot be blank " do
      user.save   
      expect(user.errors).to_not be_empty
    end

    it "email already taken" do
      user = User.new(first_name:"Ankur",
                      last_name: "Vyas", 
                      gender: "M",
                      email: "ankurvy1@gmail.com",
                      password: "12345678",
                      blocked: "false",
                      country_id: "1"
                     )
      user.save
      expect(user.errors).to be_empty


      
      other_user = User.new(first_name:"Ambika",
                      last_name: "Bhatt", 
                      gender: "F",
                      email: "ankurvy1@gmail.com",
                      password: "12345678",
                      blocked: "false",
                      country_id: "1"
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

  context "password" do
    let!(:errors) { user.save; user.errors }

    it "cannot be blank" do      
      expect(errors).to_not be_empty
    end

    it "when blank shows custom message " do      
      expect(errors.messages[:password]).to include("is required")
    end


    it "must be of minimum 8 characters" do
      expect(user.errors).to_not be_empty
    end

    it "must be of maximum 20 characters" do
      pending
    end

    it "must have atleast 1 captial letter, 1 Special symbol and 1 number " do
      pending
    end

    it "when have more than 1 captial letter, special symbol or number" do
      pending
    end

    it "when dosen't contain 1 captial letter, special symbol or number" do
      pending
    end
  end


  context "#country_id" do
    let!(:errors) { user.save; user.errors}

    it "cannot be blank" do    
      expect(errors).to_not be_empty
    end

    it "when not selected shows user-friendly message" do   
      expect(errors.messages[:country_id]).to include("must be selected")
    end

  end

  context "#blocked" do
    it "must not be blank" do
      expect(user.blocked).to be_false
    end

    it "must be false by default" do
      expect(user.blocked).to be_false
    end 

    it "must be true when set to true" do
      user.blocked = true
      expect(user.blocked).to be_true
    end   
  end 

end