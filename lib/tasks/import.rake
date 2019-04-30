namespace :import do
  desc "TODO"
  task merchant: :environment do
    require 'csv'
    CSV.foreach('./lib/merchants.csv', headers: true) do |row|
      Merchant.create(row.to_h)
    end
  end

end
