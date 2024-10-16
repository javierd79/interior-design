class UsersController < ApplicationController
  before_action :authorize_request, except: %i[create question change_password]
  before_action :find_user, except: %i[create index]

  # GET /users
  def index
    @users = User.all
    render json: @users, status: :ok
  end

  # GET /users/{username}
  def show
    render json: @user, status: :ok
  end

  # POST /users
  def create
    @user = User.new(user_params)
    if @user.save
      render json: @user, status: :created
    else
      render json: { errors: @user.errors.full_messages },
             status: :unprocessable_entity
    end
  end

  # GET /users/question/username={username}
  def question
    @questioned_user = User.find_by(username: params[:_username]) 

    if @questioned_user
      render json: { question: @questioned_user.security_question }, status: :ok
    else
      render json: { errors: "User not found" },
             status: :not_found
    end
  end

  # PUT /users/{username}
  def update
    user = @user

    unless user.update(user_params)
      render json: { errors: @user.errors.full_messages },
             status: :unprocessable_entity
    else
      render json: user, status: :ok
    end
  end

  # PUT /users/change_password
  def change_password
    @user_checked = User.find_by(username: params[:_username])
    if @user_checked.security_answer == change_password_params[:security_answer]
      unless @user_checked.update(change_password_params)
        render json: { errors: @user_checked.errors.full_messages },
               status: :unprocessable_entity
      else
        render json: @user_checked, status: :ok
      end
    else
      render json: { errors: ["Security answer did not match"] },
             status: :unprocessable_entity
    end
  end

  # DELETE /users/{username}
  def destroy
    if @user.destroy
      render json: @user, status: :accepted
    else
      render json: { message: 'Something has happened!' }, status: :unprocessable_entity
    end
  end

  private

  def find_user
    @user = User.find_by_username!(params[:_username])
    rescue ActiveRecord::RecordNotFound
      render json: { errors: 'User not found' }, status: :not_found
  end

  def user_params
    params.permit(
      :name, 
      :username, 
      :email, 
      :security_question, 
      :security_answer, 
      :password, 
      :password_confirmation
    )
  end

  def change_password_params
    params.permit(
      :security_answer, 
      :password,
    )
  end
end