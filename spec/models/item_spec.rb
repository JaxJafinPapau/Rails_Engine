require 'rails_helper'

RSpec.describe Item, type: :model do
  describe "relationships" do
    it { should belong_to(:merchant)}
  end

  describe "find_all" do
    it "should give all items with no params" do
      id = create(:merchant).id
      create_list(:item, 5, merchant_id: id)

      params = {}

      expect(Item.find_all(params).count).to eq(5)
    end
  end
end
