class Api::V1::MerchantsController < ApplicationController
  def index
    render json: MerchantSerializer.new(Merchant.find_all(params))
  end

  def show
    # Refactor this to model.
    if params[:id]
      render json: MerchantSerializer.new(Merchant.find(params[:id]))
    elsif params[:name] && !params[:id]
      render json: MerchantSerializer.new(Merchant.find_by(name: params[:name]))
    elsif params[:created_at] && !params[:id]
      render json: MerchantSerializer.new(Merchant.find_by(created_at: params[:created_at]))
    elsif params[:updated_at] && !params[:id]
      render json: MerchantSerializer.new(Merchant.find_by(updated_at: params[:updated_at]))
    elsif params[:invoice_id] && !params[:id]
      render json: MerchantSerializer.new(Merchant.joins(:invoices).where("invoices.id = ?", params[:invoice_id]))
    elsif params[:item_id] && !params[:id]
      render json: MerchantSerializer.new(Merchant.joins(:items).where("items.id = ?", params[:item_id]))
    end
  end

  #These methods could be used for an authorized user to edit the api by passing params?
  # def create
  #   render json: Merchant.create(create_params)
  # end
  #
  # def update
  #   render json: Merchant.update(update_params)
  # end
  #
  # def destroy
  #   render json: Merchant.destroy(params[:id])
  # end

  private

  # def create_params
  #   params.require(:merchant).permit(:name)
  # end

  # def update_params
  #   up = params.require(:merchant).permit(:name)
  #   up[:updated_at] = DateTime.now.strftime("%Y-%m-%d %H:%M:%S UTC")
  #   up
  # end
end
