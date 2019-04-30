class Api::V1::MerchantsController < ApplicationController
  def index
    render json: Merchant.all
  end

  def show
    render json: Merchant.find(params[:id])
  end

  def create
    render json: Merchant.create(create_params)
  end

  def update
    render json: Merchant.update(update_params)
  end

  def destroy
    render json: Merchant.destroy(params[:id])
  end

  private

  def create_params
    params.require(:merchant).permit(:name)
  end

  def update_params
    params.require(:merchant).permit(:name)
  end
end
