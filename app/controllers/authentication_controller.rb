
class AuthenticationController < ApplicationController
  before_action :authorize_request, except: :login

  # POST /auth/login
  def login
    @user = User.find_by_email(params[:email]) || User.find_by_username(params[:email])
    if @user&.authenticate(params[:password])
      token = JsonWebToken.encode(user_id: @user.id, username: @user.name, exp: 7.days.from_now)
      time = Time.now + 24.hours.to_i
      render json: { token: token, exp: time.strftime("%d-%m-%Y %H:%M"),
                     username: @user.username }, status: :ok
    else
      render json: { error: 'Unauthorized' }, status: :unauthorized
    end
  end

  private

  def login_params
    params.permit(:email, :password)
  end
end