class Api::V1::CustomersController < ApplicationController
  def index
    render json: CustomerSerializer.new(Customer.find_all(params))
  end

  def show
    render json: CustomerSerializer.new(Customer.search(params))
  end
end
