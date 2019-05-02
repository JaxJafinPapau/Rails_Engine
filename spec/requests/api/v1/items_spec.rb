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

  it "can search for an item based on the id" do
    item_1 = create(:item, name: "target item", merchant_id: @merchant.id)
    item_2 = create(:item, merchant_id: @merchant.id)
    item_3 = create(:item, merchant_id: @merchant.id)

    get "/api/v1/items/find?id=#{item_1.id}"

    found_item = JSON.parse(response.body)

    expect(response).to be_successful
    expect(found_item["data"]["attributes"]["id"]).to eq(item_1.id)
    expect(found_item["data"]["attributes"]["name"]).to eq(item_1.name)
  end
end
