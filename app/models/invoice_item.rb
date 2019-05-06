class InvoiceItem < ApplicationRecord
  belongs_to :item
  belongs_to :invoice

  def self.find_all(params)
    if params[:id]
      all.where(id: params[:id])
    elsif params[:item_id] && !params[:id]
      all.where(item_id: params[:item_id])
    elsif params[:invoice_id] && !params[:id]
      all.where(invoice_id: params[:invoice_id])
    elsif params[:quantity] && !params[:id]
      all.where(quantity: params[:quantity])
    elsif params[:unit_price] && !params[:id]
      all.where(unit_price: params[:unit_price])
    elsif params[:created_at] && !params[:id]
      all.where(created_at: params[:created_at])
    elsif params[:updated_at] && !params[:id]
      all.where(updated_at: params[:updated_at])
    else
      all
    end
  end

  def self.search(params)
    if params[:id]
      find(params[:id])
    elsif params[:item_id] && !params[:id]
      find_by(item_id: params[:item_id])
    elsif params[:invoice_id] && !params[:id]
      find_by(invoice_id: params[:invoice_id])
    elsif params[:quantity] && !params[:id]
      find_by(quantity: params[:quantity])
    elsif params[:unit_price] && !params[:id]
      find_by(unit_price: params[:unit_price])
    elsif params[:created_at] && !params[:id]
      find_by(created_at: params[:created_at])
    elsif params[:updated_at] && !params[:id]
      find_by(updated_at: params[:updated_at])
    end
  end
end
