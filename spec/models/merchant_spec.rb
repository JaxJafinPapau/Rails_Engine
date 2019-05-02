require 'rails_helper'

RSpec.describe Merchant, type: :model do
  context "relationships" do
    it {should have_many(:items)}
  end
  context "find_all" do
    it "can find_all by id" do
      merchant = create(:merchant)

      params = {
        "id": "#{merchant.id}",
        "name": "Cummings-Thiel"
      }

      expect(Merchant.find_all(params).first.id).to eq(merchant.id)
    end

    it "can find_all by name" do
      merchant_1 = create(:merchant, name: "Cummings-Thiel")
      merchant_2 = create(:merchant, name: "Cummings-Thiel")
      merchant_3 = create(:merchant)

      params = {
        "name": "Cummings-Thiel"
      }

      merchants_by_name = Merchant.find_all(params)

      expect(merchants_by_name.count).to eq(2)
      expect(merchants_by_name).to all(be_a(Merchant))
    end

    it "can find_all by created_at" do
      merchant_1 = create(:merchant, created_at: "2012-03-27T14:54:02.000Z")
      merchant_2 = create(:merchant, created_at: "2012-03-27T14:54:02.000Z")
      merchant_3 = create(:merchant)

      params = {
        "created_at": "2012-03-27T14:54:02.000Z"
      }

      merchants_by_name = Merchant.find_all(params)

      expect(merchants_by_name.count).to eq(2)
      expect(merchants_by_name).to all(be_a(Merchant))
    end

    it "can find_all by updated_at" do
      merchant_1 = create(:merchant, updated_at: "2012-03-27T14:54:02.000Z")
      merchant_2 = create(:merchant, updated_at: "2012-03-27T14:54:02.000Z")
      merchant_3 = create(:merchant)

      params = {
        "updated_at": "2012-03-27T14:54:02.000Z"
      }

      merchants_by_name = Merchant.find_all(params)

      expect(merchants_by_name.count).to eq(2)
      expect(merchants_by_name).to all(be_a(Merchant))
    end
  end
end
