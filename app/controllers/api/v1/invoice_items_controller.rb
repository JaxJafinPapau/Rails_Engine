class Api::V1::InvoiceItemsController < ApplicationController
  def index
    render json: InvoiceItemSerializer.new(InvoiceItem.find_all(params))
  end

  def show
    render json: InvoiceItemSerializer.new(InvoiceItem.search(params))
  end
end
