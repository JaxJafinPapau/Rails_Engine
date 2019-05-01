require 'csv'
namespace :import do
  desc "TODO"

  task merchant: :environment do
    CSV.foreach('./db/data/merchants.csv', headers: true) do |row|
      Merchant.create(row.to_h)
    end
  end

  task item: :environment do
    CSV.foreach('./db/data/items.csv', headers: true) do |row|
      Item.create(row.to_h)
    end
  end

  task invoice: :environment do
    CSV.foreach('./db/data/invoices.csv', headers: true) do |row|
      Invoice.create(row.to_h)
    end
  end

  task invoice_item: :environment do
    CSV.foreach('./db/data/invoice_items.csv', headers: true) do |row|
      InvoiceItem.create(row.to_h)
    end
  end

  task customer: :environment do
    CSV.foreach('./db/data/customers.csv', headers: true) do |row|
      Customer.create(row.to_h)
    end
  end

  task transaction: :environment do
    CSV.foreach('./db/data/transactions.csv', headers: true) do |row|
      Transaction.create(row.to_h)
    end
  end



  # resource_tables =  [
  #   "merchant",
  #   "item",
  #   "invoice",
  #   "invoice_item",
  #   "customer",
  #   "transaction"
  #   ]
  #
  #   task load_all: :environment do
  #     resource_tables.each do |resource_table|
  #       load(resource_table)
  #     end
  #   end
  #
  # def load(resource_table)
  #   CSV.foreach("./db/data/#{resource_table}s.csv", headers: true) do |row|
  #     "#{resource_table}".classify.constantize.create(row.to_h)
  #   end
  # end
end
