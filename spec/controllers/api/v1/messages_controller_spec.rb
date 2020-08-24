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
    end

    context 'when user has master permission' do
      it 'lists all messages that are not archived' do

        request.headers.merge!({ 'Authorization' => master.token })
        get :index

        expect(response).to have_http_status(:ok)
        expect(response.content_type).to eq("application/json")
      end
    end

    context 'when user has normal permission' do
      it 'lists all messages that were sent to the user and are not archived' do
        request.headers.merge!({ 'Authorization' => user.token })
        get :index

        expect(response).to have_http_status(:ok)
        expect(response.content_type).to eq("application/json")
      end
    end

    context 'when user token is invalid' do
      it 'receives an error message' do
        request.headers.merge!({ 'Authorization' => user.token })
        get :index

        expect(response).to have_http_status(:unauthorized)
        expect(response.content_type).to eq("application/json")
      end
    end
  end

  describe '#create' do
    before do
      allow_any_instance_of(Api::V1::MessagesController).to receive(:current_api_user) { user }
    end

    context 'when user creates a message' do
      it 'receives the message created' do

        request.headers.merge!({ 'Authorization' => user.token })
        post :create, params: { title: 'message 1', content: 'message content',
                                receiver_email: user1.email }

        expect(response).to have_http_status(:ok)
        expect(response.content_type).to eq("application/json")
      end
    end

    context 'when message is invalid' do
      it 'returns validation errors' do
        request.headers.merge!({ 'Authorization' => user.token })
        post :create, params: { title: 'message 1', receiver_email: user1.email }

        expect(response).to have_http_status(:bad_request)
        expect(response.content_type).to eq("application/json")
        expect(assigns(:message)).to_not be_valid

      end
    end
  end

  describe '#sent' do
    before do
      allow_any_instance_of(Api::V1::MessagesController).to receive(:current_api_user) { user }
    end

    it 'shows all messages sent by the user' do

      request.headers.merge!({ 'Authorization' => user.token })
      get :sent

      expect(response).to have_http_status(:ok)
      expect(response.content_type).to eq("application/json")
    end

    context 'when user token is invalid' do
      it 'receives an error message' do
        request.headers.merge!({ 'Authorization' => user.token })
        get :index

        expect(response).to have_http_status(:unauthorized)
        expect(response.content_type).to eq("application/json")
      end
    end
  end

  describe '#show' do
    before do
      allow_any_instance_of(Api::V1::MessagesController).to receive(:current_api_user) { user }
    end

    it 'shows a message requested by the user if is unread, mark as read' do

      request.headers.merge!({ 'Authorization' => user.token })
      get :show, params: { id: message.id }

      expect(response).to have_http_status(:ok)
      expect(response.content_type).to eq("application/json")
    end
  end
end
