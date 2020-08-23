class Api::BaseController < ApplicationController
  include Pagy::Backend

  skip_before_action :verify_authenticity_token

  before_action :current_api_user
  before_action :validate_user

  private

  def current_api_user
    User.where(token: request.headers['Authorization']).first if request.headers['Authorization'].present?
  end

  def validate_user
    render json: { error: "Unauthorized" }, status: 401 if current_api_user.nil?
  end
end
