class RemoveCreditCardExpirationFromTransactions < ActiveRecord::Migration[5.2]
  def change
    remove_column :transactions, :credit_card_expiration_date
  end
end
