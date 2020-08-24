require 'rails_helper'

RSpec.describe Api::V1::UsersController, type: :controller do
  let(:user) { FactoryBot.create(:user)}


 describe '#show' do
   before do
     allow_any_instance_of(Api::V1::UsersController).to receive(:current_api_user) { user }
   end

   context 'when user has valid token' do
     it 'show user profile' do
       request.headers.merge!({ 'Authorization' => user.token })

       get :index
       expect(response).to have_http_status(:ok)
     end
   end
 end

 describe '#update' do
   before do
     allow_any_instance_of(Api::V1::UsersController).to receive(:current_api_user) { user }
   end

   context 'when user updates its profile' do
     it 'updates user and returns the user that was updated' do
       request.headers.merge!({ 'Authorization' => user.token })

       patch :update, params: { user: {name: 'Editado', email: 'editado@email.com'}}
       expect(response).to have_http_status(:ok)
     end
   end
 end
end
