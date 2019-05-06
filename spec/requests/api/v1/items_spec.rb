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

  it "can search for an item based on created_at" do
    item_1 = create(:item, created_at: "2012-03-27T14:54:05.000Z", merchant_id: @merchant.id)
    item_2 = create(:item, merchant_id: @merchant.id)
    item_3 = create(:item, merchant_id: @merchant.id)

    # binding.pry
    get "/api/v1/items/find?created_at=#{item_1.created_at}"

    found_item = JSON.parse(response.body)

    expect(found_item["data"]["attributes"]["id"]).to eq(item_1.id)
    expect(found_item["data"]["attributes"]["name"]).to eq(item_1.name)
  end

  it "can search for an item based on updated_at" do
    item_1 = create(:item, created_at: "2012-03-27T14:54:05.000Z", updated_at: "2013-03-27T14:54:05.000Z", merchant_id: @merchant.id)
    item_2 = create(:item, merchant_id: @merchant.id)
    item_3 = create(:item, merchant_id: @merchant.id)

    get "/api/v1/items/find?updated_at=#{item_1.updated_at}"

    found_item = JSON.parse(response.body)

    expect(found_item["data"]["attributes"]["id"]).to eq(item_1.id)
    expect(found_item["data"]["attributes"]["name"]).to eq(item_1.name)
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

  it "can find_all items by description and return a serialized array" do
    item_1 = create(:item, description: "the best item", merchant_id: @merchant.id)
    item_2 = create(:item, description: "the best item", merchant_id: @merchant.id)
    item_3 = create(:item, merchant_id: @merchant.id)

    get "/api/v1/items/find_all?description=#{item_1.description}"

    found_items = JSON.parse(response.body)

    expect(response).to be_successful
    expect(found_items["data"].count).to eq(2)
    expect(found_items["data"]).to be_an(Array)
    expect(found_items["data"].first["attributes"]["description"]).to eq(item_1.description)
  end

  it "can find_all items by unit_price and return a serialized array" do
    item_1 = create(:item, unit_price: 0.01, merchant_id: @merchant.id)
    item_2 = create(:item, unit_price: 0.01, merchant_id: @merchant.id)
    item_3 = create(:item, merchant_id: @merchant.id)

    get "/api/v1/items/find_all?unit_price=#{item_1.unit_price}"

    found_items = JSON.parse(response.body)

    expect(response).to be_successful
    expect(found_items["data"].count).to eq(2)
    expect(found_items["data"]).to be_an(Array)
    expect(found_items["data"].first["attributes"]["unit_price"]).to eq(item_1.unit_price)
  end

  it "can find_all items by merchant_id and return a serialized array" do
    item_1 = create(:item, merchant_id: @merchant.id)
    item_2 = create(:item, merchant_id: @merchant.id)
    other_merchant = create(:merchant)
    item_3 = create(:item, merchant_id: other_merchant.id)

    get "/api/v1/items/find_all?merchant_id=#{item_1.merchant_id}"

    found_items = JSON.parse(response.body)

    expect(response).to be_successful
    expect(found_items["data"].count).to eq(2)
    expect(found_items["data"]).to be_an(Array)
    expect(found_items["data"].first["attributes"]["merchant_id"]).to eq(item_1.merchant_id)
  end

  it "can find_all items by created_at and return a serialized array" do
    item_1 = create(:item, merchant_id: @merchant.id, created_at: "2012-03-27T14:54:05.000Z")
    item_2 = create(:item, merchant_id: @merchant.id, created_at: "2012-03-27T14:54:05.000Z")
    item_3 = create(:item, merchant_id: @merchant.id, created_at: "2014-05-29T14:54:05.000Z")

    get "/api/v1/items/find_all?created_at=#{item_1.created_at}"

    found_items = JSON.parse(response.body)

    expect(response).to be_successful
    expect(found_items["data"].count).to eq(2)
    expect(found_items["data"]).to be_an(Array)
    expect(found_items["data"].first["attributes"]["id"]).to eq(item_1.id)
  end

  it "can find_all items by updated_at and return a serialized array" do
    item_1 = create(:item, merchant_id: @merchant.id, updated_at: "2013-03-27T14:54:05.000Z", created_at: "2012-03-27T14:54:05.000Z")
    item_2 = create(:item, merchant_id: @merchant.id, updated_at: "2013-03-27T14:54:05.000Z", created_at: "2012-03-27T14:54:05.000Z")
    item_3 = create(:item, merchant_id: @merchant.id, updated_at: "2015-05-29T14:54:05.000Z", created_at: "2012-03-27T14:54:05.000Z")

    get "/api/v1/items/find_all?updated_at=#{item_1.updated_at}"

    found_items = JSON.parse(response.body)

    expect(response).to be_successful
    expect(found_items["data"].count).to eq(2)
    expect(found_items["data"]).to be_an(Array)
    expect(found_items["data"].first["attributes"]["id"]).to eq(item_1.id)
  end

  describe "relational endpoints" do
    it "can return its invoice_items" do
      item_1 = create(:item, merchant_id: @merchant.id)
      customer = create(:customer)
      invoice = create(:invoice, customer_id: customer.id, merchant_id: @merchant.id)
      invoice_item = create(:invoice_item, item_id: item_1.id, invoice_id: invoice.id)

      get "/api/v1/items/#{item_1.id}/invoice_items"

      found_invoice_item = JSON.parse(response.body)
      expect(response).to be_successful
      expect(found_invoice_item["data"].first["attributes"]["id"]).to eq(invoice_item.id)
    end

    it "can return its merchant" do
      item_1 = create(:item, merchant_id: @merchant.id)

      get "/api/v1/items/#{item_1.id}/merchant"

      found_merchant = JSON.parse(response.body)

      expect(response).to be_successful
      expect(found_merchant["data"].first["attributes"]["id"]).to eq(@merchant.id)
    end
  end
end
