require 'rails_helper'

RSpec.describe Api::V1::MessagesController, type: :controller do

  let(:user) { FactoryBot.create(:user)}
  let(:user1) { FactoryBot.create(:user)}
  let(:master) { FactoryBot.create(:user,:master)}
  let(:message) { FactoryBot.create(:message,to: user.id,from: user1.id)}
  let(:message1) { FactoryBot.create(:message,to: user1.id,from: user.id)}
  let(:read_message) { FactoryBot.create(:message,:read,to: user.id)}
  let(:archived_message) { FactoryBot.create(:message,:archived,to: user.id)}
  let(:archived_message1) { FactoryBot.create(:message,:archived,to: user1.id)}

  describe '#index' do
    before do
      allow_any_instance_of(Api::V1::MessagesController).to receive(:current_api_user) { master }
      @headers = { 'Authorization' => master.token }
    end

    context 'when user has master permission' do
      it 'lists all messages that are not archived' do

        request.headers.merge! @headers
        get :index

        expect(response).to have_http_status(:ok)
        expect(response.content_type).to eq("application/json")
      end
    end
  end

end
