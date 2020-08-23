class Api::V1::MessagesController < Api::BaseController

  # Lists all messages if current_api_user is master or messages sent by current_api_user if it isn't master
  def index
    pagy, messages = pagy(current_api_user.master? ? Message.master_messages.ordered : Message.sent_to(current_api_user).ordered, items: 10)

    render json: { pagination: pagy, messages: messages }, status: 200
  end

# Creates a new message sent by current_api_user
  def create
    user = User.find_by_email(message_params[:receiver_email])
    message = Message.new(message_params.merge(from: current_api_user.id))
    if user
      message.to = user.id
    else
      render json: { error: "Usuário não encontrado." }, status: 400 and return
    end

    if message.save
      render json: message, status: 200
    else
      render json: { errors: message.errors.full_messages }, status: 400
    end
  end

  def sent
    messages = Message.sent_from(current_api_user).ordered

    render json: messages, status: 200
  end

  def show
    message = Message.find(params[:id])
    if message.unread? && current_api_user == message.receiver
      message.read!
    end

    render json: message, status: 200
  end

  private

  def message_params
    params.require(:message).permit(
      :title,
      :content,
      :receiver_email,
      :to
    )
  end
end
