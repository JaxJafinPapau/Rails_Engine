class Transaction < ApplicationRecord
  belongs_to :invoice
  def self.find_all(params)
    if params[:id]
      all.where(id: params[:id])
    elsif params[:invoice_id] && !params[:id]
      all.where(invoice_id: params[:invoice_id])
    elsif params[:credit_card_number] && !params[:id]
      all.where(credit_card_number: params[:credit_card_number])
    elsif params[:credit_card_expiration_date] && !params[:id]
      all.where(credit_card_expiration_date: params[:credit_card_expiration_date])
    elsif params[:result] && !params[:id]
      all.where(result: params[:result])
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
    elsif params[:invoice_id] && !params[:id]
      find_by(invoice_id: params[:invoice_id])
    elsif params[:credit_card_number] && !params[:id]
      find_by(credit_card_number: params[:credit_card_number])
    elsif params[:credit_card_expiration_date] && !params[:id]
      find_by(credit_card_expiration_date: params[:credit_card_expiration_date])
    elsif params[:result] && !params[:id]
      find_by(result: params[:result])
    elsif params[:created_at] && !params[:id]
      find_by(created_at: params[:created_at])
    elsif params[:updated_at] && !params[:id]
      find_by(updated_at: params[:updated_at])
    end
  end
end
