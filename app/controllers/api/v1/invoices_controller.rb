class Api::V1::InvoicesController < ApplicationController
  def index
    render json: InvoiceSerializer.new(Invoice.find_all(params))
  end

  def show
    render json: InvoiceSerializer.new(Invoice.search(params))
  end
end
