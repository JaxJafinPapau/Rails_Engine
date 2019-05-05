require 'rails_helper'

RSpec.describe Transaction, type: :model do
  describe "find_all" do
    it "should give all transactions with no params" do
      merch_id = create(:merchant).id
      cust_id = create(:customer).id
      inv_id = create(:invoice, merchant_id: merch_id, customer_id: cust_id).id
      create_list(:transaction, 5, invoice_id: inv_id)

      params = {}

      expect(Transaction.find_all(params).count).to eq(5)
    end
  end

  #write tests for the full functionality of these methods

  describe "search" do
    it "should return the first transaction with matching id" do
      merch_id = create(:merchant).id
      cust_id = create(:customer).id
      inv_id = create(:invoice, merchant_id: merch_id, customer_id: cust_id).id
      transaction = create(:transaction, invoice_id: inv_id)

      params = {id: transaction.id}

      expect(Transaction.search(params).id).to eq(transaction.id)
    end
  end
end
