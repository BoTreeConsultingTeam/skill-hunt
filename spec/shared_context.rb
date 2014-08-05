shared_context 'initialize_common_objects' do
  let(:params) { { format: :json } }
  let(:response_json) { JSON.parse(response.body) }
  let(:admin_user_role) { FactoryGirl.create(:role_admin) }        
  let(:end_user_role)   { FactoryGirl.create(:role_end_user) }
  let(:company_representative_role) { FactoryGirl.create(:role_company_representative)}
  let!(:india_country) { FactoryGirl.create(:india_country) }

  let(:admin_user_attrs) {
    FactoryGirl.create(:admin_user, :country => india_country)
  }

  let(:other_user_attrs){
    FactoryGirl.create(:end_user, :country => india_country)
  }

  let(:admin_user) { admin_user_attrs.role = admin_user_role 
                     admin_user_attrs } 

  let(:end_user) { other_user_attrs.role = end_user_role
                   other_user_attrs}

  def dummy_auth_token
    "dummy auth token"
  end

  def update_user_authentication_token(user, auth_token)
    user.update_attribute(:authentication_token, auth_token)
  end

  def update_user_authentication(token, user)
    update_user_authentication_token(user, token)
    params.merge!(authentication_token: token)
  end

  def set_current_user(user)
    token = get_token(user)
    update_user_authentication(token, user)
  end

  def get_token(user)
    user.is_administrator? ? dummy_auth_token : 'token' 
  end
end