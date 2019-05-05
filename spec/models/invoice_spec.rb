require 'rails_helper'

RSpec.describe Invoice, type: :model do
  before :each do
    @customer = create(:customer)
    @merchant = create(:merchant)
  end
  describe "find_all" do
    it "should give all invoices with no params" do
      create_list(:invoice, 5, customer_id: @customer.id, merchant_id: @merchant.id)

      params = {}

      expect(Invoice.find_all(params).count).to eq(5)
    end
  end

  #write tests for the full functionality of these methods

  describe "search" do
    it "should return the first invoice with matching id" do
      invoice = create(:invoice, customer_id: @customer.id, merchant_id: @merchant.id)

      params = {id: invoice.id}

      expect(Invoice.search(params).id).to eq(invoice.id)
    end
  end
end
