require 'rails_helper'

describe "Items API", type: :request do
  before :each do
    @merchant = create(:merchant)
  end
  it "sends a list of items" do
    create_list(:item, 5, merchant_id: @merchant.id)

    get '/api/v1/items'

    expect(response).to be_successful

    items = JSON.parse(response.body)

    expect(items["data"].count).to eq(5)
  end

  it "can show one item" do
    item_resource = create(:item, merchant_id: @merchant.id)

    get "/api/v1/items/#{item_resource.id}"

    expect(response).to be_successful

    item = JSON.parse(response.body)

    expect(item["data"]["attributes"]["id"]).to eq(item_resource.id)
  end
end
