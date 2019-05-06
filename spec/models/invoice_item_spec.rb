require 'rails_helper'

RSpec.describe InvoiceItem, type: :model do
  before :each do
    @merchant = create(:merchant)
    @customer = create(:customer)
    @item = create(:item, merchant_id: @merchant.id)
    @invoice = create(:invoice, merchant_id: @merchant.id, customer_id: @customer.id)
  end
  describe "find_all" do
    it "should give all invoice_items with no params" do
      create_list(:invoice_item, 5, item_id: @item.id, invoice_id: @invoice.id)

      params = {}

      expect(InvoiceItem.find_all(params).count).to eq(5)
    end
  end

  #write tests for the full functionality of these methods

  describe "search" do
    it "should return the first invoice_item with matching id" do
      invoice_item = create(:invoice_item, item_id: @item.id, invoice_id: @invoice.id)

      params = {id: invoice_item.id}

      expect(InvoiceItem.search(params).id).to eq(invoice_item.id)
    end
  end
end
