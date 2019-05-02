class Item < ApplicationRecord
  belongs_to :merchant

  def self.find_all(params)
    if params[:id]
      all.where(id: params[:id])
    # elsif params[:name] && !params[:id]
    #   all.where(name: params[:name])
    # elsif params[:description] && !params[:id]
    #   all.where(description: params[:description])
    # elsif params[:unit_price] && !params[:id]
    #   all.where(unit_price: params[:unit_price])
    # elsif params[:merchant_id] && !params[:id]
    #   all.where(merchant_id: params[:merchant_id])
    # elsif params[:merchant_id] && !params[:id]
    #   all.where(merchant_id: params[:merchant_id])
    # elsif params[:created_at] && !params[:id]
    #   all.where(created_at: params[:created_at])
    # elsif params[:updated_at] && !params[:id]
    #   all.where(updated_at: params[:updated_at])
    else
      all
    end
  end
end
