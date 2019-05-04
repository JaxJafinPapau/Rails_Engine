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

  it "can search for an item based on the name" do
    item_1 = create(:item, name: "target item", merchant_id: @merchant.id)
    item_2 = create(:item, merchant_id: @merchant.id)
    item_3 = create(:item, merchant_id: @merchant.id)

    get "/api/v1/items/find?name=#{item_1.name}"

    found_item = JSON.parse(response.body)

    expect(response).to be_successful
    expect(found_item["data"]["attributes"]["id"]).to eq(item_1.id)
    expect(found_item["data"]["attributes"]["name"]).to eq(item_1.name)
  end

  it "can search for an item based on the description" do
    item_1 = create(:item, description: "the best item", merchant_id: @merchant.id)
    item_2 = create(:item, merchant_id: @merchant.id)
    item_3 = create(:item, merchant_id: @merchant.id)

    get "/api/v1/items/find?description=#{item_1.description}"

    found_item = JSON.parse(response.body)

    expect(response).to be_successful
    expect(found_item["data"]["attributes"]["id"]).to eq(item_1.id)
    expect(found_item["data"]["attributes"]["description"]).to eq(item_1.description)
  end

  it "can search for an item based on the unit_price" do
    item_1 = create(:item, unit_price: 0.01, merchant_id: @merchant.id)
    item_2 = create(:item, merchant_id: @merchant.id)
    item_3 = create(:item, merchant_id: @merchant.id)

    get "/api/v1/items/find?unit_price=#{item_1.unit_price}"

    found_item = JSON.parse(response.body)

    expect(response).to be_successful
    expect(found_item["data"]["attributes"]["id"]).to eq(item_1.id)
    expect(found_item["data"]["attributes"]["unit_price"]).to eq(item_1.unit_price)
  end

  it "can search for an item based on the merhcant_id" do
    item_1 = create(:item, merchant_id: @merchant.id)
    not_this_merchant = create(:merchant)
    item_2 = create(:item, merchant_id: not_this_merchant.id)
    item_3 = create(:item, merchant_id: not_this_merchant.id)

    get "/api/v1/items/find?merchant_id=#{item_1.merchant_id}"

    found_item = JSON.parse(response.body)

    expect(response).to be_successful
    expect(found_item["data"]["attributes"]["id"]).to eq(item_1.id)
    expect(found_item["data"]["attributes"]["merchant_id"]).to eq(item_1.merchant_id)
  end

  it "can search for all items based on the id" do
    item_1 = create(:item, name: "target item", merchant_id: @merchant.id)
    item_2 = create(:item, merchant_id: @merchant.id)
    item_3 = create(:item, merchant_id: @merchant.id)

    get "/api/v1/items/find_all?id=#{item_1.id}"

    found_items = JSON.parse(response.body)

    expect(response).to be_successful
    expect(found_items["data"]).to be_an(Array)
    expect(found_items["data"].first["id"].to_i).to eq(item_1.id)
  end

  it "can find_all items by name and return a serialized array" do
    item_1 = create(:item, name: "target item", merchant_id: @merchant.id)
    item_2 = create(:item, name: "target item", merchant_id: @merchant.id)
    item_3 = create(:item, merchant_id: @merchant.id)

    get "/api/v1/items/find_all?name=#{item_1.name}"

    found_items = JSON.parse(response.body)

    expect(response).to be_successful
    expect(found_items["data"].count).to eq(2)
    expect(found_items["data"]).to be_an(Array)
    expect(found_items["data"].first["attributes"]["name"]).to eq(item_1.name)
  end
end
