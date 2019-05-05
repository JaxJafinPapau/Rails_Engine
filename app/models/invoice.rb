class Invoice < ApplicationRecord
  belongs_to :customer
  belongs_to :merchant

  def self.find_all(params)
    if params[:id]
      all.where(id: params[:id])
    elsif params[:first_name] && !params[:id]
      all.where(first_name: params[:first_name])
    elsif params[:last_name] && !params[:id]
      all.where(last_name: params[:last_name])
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
    elsif params[:first_name] && !params[:id]
      find_by(first_name: params[:first_name])
    elsif params[:last_name] && !params[:id]
      find_by(last_name: params[:last_name])
    elsif params[:created_at] && !params[:id]
      find_by(created_at: params[:created_at])
    elsif params[:updated_at] && !params[:id]
      find_by(updated_at: params[:updated_at])
    end
  end
end
