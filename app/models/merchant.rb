class Merchant < ApplicationRecord
  has_many :items
  has_many :invoices
  def self.find_all(params)
    if params[:id]
      all.where(id: params[:id])
    elsif params[:name] && !params[:id]
      all.where(name: params[:name])
    elsif params[:created_at] && !params[:id]
      all.where(created_at: params[:created_at])
    elsif params[:updated_at] && !params[:id]
      all.where(updated_at: params[:updated_at])
    else
      all
    end
  end
end
