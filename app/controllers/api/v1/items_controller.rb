class Api::V1::ItemsController < ApplicationController
  def index
    render json: ItemSerializer.new(Item.find_all(params))
  end

  def show
    render json: ItemSerializer.new(Item.search(params))
  end
end
