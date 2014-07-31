shared_context 'initialize_common_objects' do
  let(:params) { { format: :json } }
  let(:response_json) { JSON.parse(response.body) }
  let(:admin_user_role) { Role.create( role_name:'administrator') }        
  let(:end_user_role)   { Role.create( role_name:'end_user') }
  let!(:india) { Country.create(country_name: 'India') }
  let(:user_attrs) {
    {
      user: {
          first_name: 'TestFirstName',
          last_name: 'TestLastName',
          gender: 'M',
          email: 'test_email@example.com',
          password: 'Test1$aaaaaa',
          country_id: india.id
        }
    }
  }

  let(:admin_user_attrs) { 
    User.create(  first_name: 'Raju',
                  last_name: 'Bhai',
                  gender: 'M',
                  email: 'raju@example.com',
                  password: 'A1$aaabba',
                  country_id: india.id )
  }

  let(:other_user_attrs){
    User.create(  first_name: 'Ankur',
                  last_name: 'Vyas',
                  gender: 'M',
                  email: 'ankur@example.com',
                  password: 'A1$aaabba',
                  country_id: india.id )
  }

  let(:admin_user) { admin_user_attrs.role = admin_user_role 
                     admin_user_attrs } 

  let(:end_user) { other_user_attrs.role = end_user_role
                   other_user_attrs}

  let(:current_user) { admin_user }
end


shared_context 'initialized_objects_for_user' do
  include_context 'initialize_common_objects'
  
  let!(:america) { Country.create(country_name: 'America') }
  let(:user_json) { response_json['user'] }
end

shared_context 'initialized_objects_for_skill' do
  include_context 'initialize_common_objects'

  let(:skill_json) { response_json['skill'] }
  let!(:category) { Category.create(name: 'Database') }

  let(:skills_attr){
    {
      skill:{
        skill_name: 'Ruby',
        skill_desc: 'Dynamic type Language',
        category_id: category.id
      }
    }
  }
end

shared_context 'initialized_objects_for_category' do
  include_context 'initialize_common_objects'

  let(:category_json) { response_json['category'] }

  let(:categories_attr){
    {
      category: {
        name: "Database"
      }
    }
  }
end

shared_context 'initialized_objects_for_company' do
  include_context 'initialize_common_objects'

  let(:company_json) { response_json["company"] }
  let(:company_attrs){
    {
    company: {
      company_name: "TCS"
      }
    }
  }
end