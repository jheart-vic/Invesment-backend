class TransactionsController < ApplicationController
  before_action :authenticate_user!

  def index
    @transactions = current_user.transactions
    render json: @transactions
  end

  def deposit
    @transaction = Transaction.deposit(current_user, params[:amount], params[:currency])
    if @transaction.persisted?
      render json: @transaction
    else
      render json: { errors: @transaction.errors }, status: :unprocessable_entity
    end
  end

  def withdraw
    @transaction = Transaction.withdraw(current_user, params[:amount], params[:currency])
    if @transaction.persisted?
      render json: @transaction
    else
      render json: { errors: @transaction.errors }, status: :unprocessable_entity
    end
  end
end
