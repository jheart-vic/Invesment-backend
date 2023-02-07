class UsersController < ApplicationController
  before_action :set_user, only: %i[ show update destroy ]

  # GET /users
  def index
    @users = User.all

    render json: @users
  end

  # GET /users/1
  def show
    render json: @user
  end

  # POST /users
  def create
    @user = User.new(user_params)
    @user.verification_code = SecureRandom.hex(4)
    if @user.save
      UserMailer.with(user: @user, verification_code: @user.verification_code).welcome_email.deliver_later
      render json: { message: 'User created successfully' }, status: :created
    else
      render json: { errors: @user.errors }, status: :unprocessable_entity
    end
  end

  private

  # def user_params
  #   params.require(:user).permit(:email, :password)
  # end

  # PATCH/PUT /users/1
  def update
    if @user.update(user_params)
      render json: @user
    else
      render json: @user.errors, status: :unprocessable_entity
    end
  end

  # DELETE /users/1
  def destroy
    @user.destroy
  end

    # Use callbacks to share common setup or constraints between actions.
    def set_user
      @user = User.find(params[:id])
    end

    # # Only allow a list of trusted parameters through.
    def user_params
      params.fetch(:user, {})
    end
end
