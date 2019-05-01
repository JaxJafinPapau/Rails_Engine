class Merchant < ApplicationRecord
  def self.find_all(params)
    if params[:id]
      Merchant.all.where(id: params[:id])
    elsif params[:name] && !params[:id]
      Merchant.all.where(name: params[:name])
    elsif params[:created_at] && !params[:id]
      Merchant.all.where(created_at: params[:created_at])
    elsif params[:updated_at] && !params[:id]
      Merchant.all.where(updated_at: params[:updated_at])
    else
      Merchant.all
    end
  end
end
