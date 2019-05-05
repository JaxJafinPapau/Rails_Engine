class Api::V1::TransactionsController < ApplicationController
  def index
    render json: TransactionSerializer.new(Transaction.find_all(params))
  end

  def show
    render json: TransactionSerializer.new(Transaction.search(params))
  end
end
