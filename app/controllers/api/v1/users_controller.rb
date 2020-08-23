class Api::V1::UsersController < Api::BaseController

  def show
    render json: current_api_user, status: 200
  end

  def update
    if user_params[:password].blank? || user_params[:password_confirmation].blank? # remove password if both fields are not filled
      params[:user].delete(:password)
      params[:user].delete(:password_confirmation)
    end

    if current_api_user.update(user_params)
      render json: current_api_user, status: 200
    else
      render json: { errors: current_api_user.errors.full_messages }, status: 400
    end
  end

  private

  def user_params
    params.require(:user).permit(
      :name,
      :email,
      :password,
      :password_confirmation
    )
  end
end
