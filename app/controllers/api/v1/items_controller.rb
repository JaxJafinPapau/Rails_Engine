class Api::V1::ItemsController < ApplicationController
  def index
    render json: ItemSerializer.new(Item.find_all(params))
  end

  def show
    if params[:id]
      render json: ItemSerializer.new(Item.find(params[:id]))
    elsif params[:name] && !params[:id]
      render json: ItemSerializer.new(Item.find_by(name: params[:name]))
    end
  end
end
