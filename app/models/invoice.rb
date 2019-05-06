class Invoice < ApplicationRecord
  belongs_to :customer
  belongs_to :merchant

  has_many :invoice_items
  has_many :transactions

  def self.find_all(params)
    if params[:id]
      all.where(id: params[:id])
    elsif params[:status] && !params[:id]
      all.where(status: params[:status])
    elsif params[:customer_id] && !params[:id]
      all.where(customer_id: params[:customer_id])
    elsif params[:merchant_id] && !params[:id]
      all.where(merchant_id: params[:merchant_id])
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
    elsif params[:status] && !params[:id]
      find_by(status: params[:status])
    elsif params[:customer_id] && !params[:id]
      find_by(customer_id: params[:customer_id])
    elsif params[:merchant_id] && !params[:id]
      find_by(merchant_id: params[:merchant_id])
    elsif params[:created_at] && !params[:id]
      find_by(created_at: params[:created_at])
    elsif params[:updated_at] && !params[:id]
      find_by(updated_at: params[:updated_at])
    elsif params[:invoice_item_id] && !params[:id]
      joins(:invoice_items).where("invoice_items.id =?", params[:invoice_item_id])
    elsif params[:transaction_id] && !params[:id]
      joins(:transactions).where("transactions.id = ?", params[:transaction_id])
    end
  end
end
