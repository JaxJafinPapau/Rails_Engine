require 'rails_helper'

describe "InvoiceItems API", type: :request do
  before :each do
    @merchant = create(:merchant)
    @merchant_2 = create(:merchant)
    @customer = create(:customer)
    @customer_2 = create(:customer)
    @item = create(:item, merchant_id: @merchant.id)
    @item_2 = create(:item, merchant_id: @merchant_2.id)
    @invoice = create(:invoice, merchant_id: @merchant.id, customer_id: @customer.id)
    @invoice_2 = create(:invoice, merchant_id: @merchant_2.id, customer_id: @customer_2.id, status: "shipped", created_at: "2012-03-09T08:57:21.000Z", updated_at: "2013-03-09T08:57:21.000Z")
    @invoice_item = create(:invoice_item, item_id: @item.id, invoice_id: @invoice.id)
    @invoice_item_2 = create(:invoice_item, item_id: @item_2.id, invoice_id: @invoice_2.id, quantity: 2, created_at: "2012-03-09T08:57:21.000Z", updated_at: "2013-03-09T08:57:21.000Z")
    @invoice_item_3 = create(:invoice_item, item_id: @item_2.id, invoice_id: @invoice_2.id, quantity: 2, created_at: "2012-03-09T08:57:21.000Z", updated_at: "2013-03-09T08:57:21.000Z")
  end

  it "sends a list of invoice_items" do
    get '/api/v1/invoice_items'

    expect(response).to be_successful

    invoice_items = JSON.parse(response.body)

    expect(invoice_items["data"].count).to eq(3)
  end

  it "can show one invoice_item" do
    get "/api/v1/invoice_items/#{@invoice_item.id}"

    expect(response).to be_successful

    invoice_item = JSON.parse(response.body)

    expect(invoice_item["data"]["attributes"]["id"]).to eq(@invoice_item.id)
  end

  it "can search for a invoice_item based on the id" do
    get "/api/v1/invoice_items/find?id=#{@invoice_item.id}"

    found_invoice_item = JSON.parse(response.body)

    expect(response).to be_successful
    expect(found_invoice_item["data"]["attributes"]["id"]).to eq(@invoice_item.id)
  end

  it "can search for a invoice_item based on the item_id" do
    get "/api/v1/invoice_items/find?item_id=#{@invoice_item.item_id}"

    found_invoice_item = JSON.parse(response.body)

    expect(response).to be_successful
    expect(found_invoice_item["data"]["attributes"]["id"]).to eq(@invoice_item.id)
    expect(found_invoice_item["data"]["attributes"]["item_id"]).to eq(@invoice_item.item_id)
  end

  it "can search for a invoice_item based on the invoice_id" do
    get "/api/v1/invoice_items/find?invoice_id=#{@invoice_item.invoice_id}"

    found_invoice_item = JSON.parse(response.body)

    expect(response).to be_successful
    expect(found_invoice_item["data"]["attributes"]["id"]).to eq(@invoice_item.id)
    expect(found_invoice_item["data"]["attributes"]["invoice_id"]).to eq(@invoice_item.invoice_id)
  end

  it "can search for a invoice_item based on the quantity" do
    get "/api/v1/invoice_items/find?quantity=#{@invoice_item.quantity}"

    found_invoice_item = JSON.parse(response.body)

    expect(response).to be_successful
    expect(found_invoice_item["data"]["attributes"]["id"]).to eq(@invoice_item.id)
    expect(found_invoice_item["data"]["attributes"]["quantity"]).to eq(@invoice_item.quantity)
  end

  it "can search for a invoice_item based on the unit_price" do
    get "/api/v1/invoice_items/find?unit_price=#{@invoice_item.unit_price}"

    found_invoice_item = JSON.parse(response.body)

    expect(response).to be_successful
    expect(found_invoice_item["data"]["attributes"]["id"]).to eq(@invoice_item.id)
    expect(found_invoice_item["data"]["attributes"]["unit_price"]).to eq(@invoice_item.unit_price)
  end

  it "can search for a invoice_item based on created_at" do
    invoice_item_1 = create(:invoice_item, created_at: "2012-03-27T14:54:05.000Z", item_id: @item.id, invoice_id: @invoice.id)

    get "/api/v1/invoice_items/find?created_at=#{invoice_item_1.created_at}"

    found_invoice_item = JSON.parse(response.body)

    expect(found_invoice_item["data"]["attributes"]["id"]).to eq(invoice_item_1.id)
  end

  it "can search for a invoice_item based on updated_at" do
    invoice_item_1 = create(:invoice_item, created_at: "2012-03-27T14:54:05.000Z", updated_at: "2013-03-27T14:54:05.000Z", item_id: @item.id, invoice_id: @invoice.id)

    get "/api/v1/invoice_items/find?updated_at=#{invoice_item_1.updated_at}"

    found_invoice_item = JSON.parse(response.body)

    expect(found_invoice_item["data"]["attributes"]["id"]).to eq(invoice_item_1.id)
  end

  it "can search for all invoice_items based on the id" do
    get "/api/v1/invoice_items/find_all?id=#{@invoice_item_2.id}"

    found_invoice_items = JSON.parse(response.body)

    expect(response).to be_successful
    expect(found_invoice_items["data"]).to be_an(Array)
    expect(found_invoice_items["data"].first["id"].to_i).to eq(@invoice_item_2.id)
  end

  it "can find_all invoice_items by item_id and return a serialized array" do
    get "/api/v1/invoice_items/find_all?item_id=#{@invoice_item_2.item_id}"

    found_invoice_items = JSON.parse(response.body)

    expect(response).to be_successful
    expect(found_invoice_items["data"].count).to eq(2)
    expect(found_invoice_items["data"]).to be_an(Array)
    expect(found_invoice_items["data"].first["attributes"]["item_id"]).to eq(@invoice_item_2.item_id)
  end

  it "can find_all invoice_items by invoice_id and return a serialized array" do
    get "/api/v1/invoice_items/find_all?invoice_id=#{@invoice_item_2.invoice_id}"

    found_invoice_items = JSON.parse(response.body)

    expect(response).to be_successful
    expect(found_invoice_items["data"].count).to eq(2)
    expect(found_invoice_items["data"]).to be_an(Array)
    expect(found_invoice_items["data"].first["attributes"]["invoice_id"]).to eq(@invoice_item_2.invoice_id)
  end

  it "can find_all invoice_items by quantity and return a serialized array" do
    get "/api/v1/invoice_items/find_all?quantity=#{@invoice_item_2.quantity}"

    found_invoice_items = JSON.parse(response.body)

    expect(response).to be_successful
    expect(found_invoice_items["data"].count).to eq(2)
    expect(found_invoice_items["data"]).to be_an(Array)
    expect(found_invoice_items["data"].first["attributes"]["quantity"]).to eq(@invoice_item_2.quantity)
  end

  it "can find_all invoice_items by created_at and return a serialized array" do
    get "/api/v1/invoice_items/find_all?created_at=#{@invoice_item_2.created_at}"

    found_invoice_items = JSON.parse(response.body)

    expect(response).to be_successful
    expect(found_invoice_items["data"].count).to eq(2)
    expect(found_invoice_items["data"]).to be_an(Array)
    expect(found_invoice_items["data"].first["attributes"]["id"]).to eq(@invoice_item_2.id)
  end

  it "can find_all invoice_items by updated_at and return a serialized array" do
    get "/api/v1/invoice_items/find_all?updated_at=#{@invoice_item_2.updated_at}"

    found_invoice_items = JSON.parse(response.body)

    expect(response).to be_successful
    expect(found_invoice_items["data"].count).to eq(2)
    expect(found_invoice_items["data"]).to be_an(Array)
    expect(found_invoice_items["data"].first["attributes"]["id"]).to eq(@invoice_item_2.id)
  end

  describe "relational endpoints" do
    it "can return its invoice" do
      get "/api/v1/invoice_items/#{@invoice_item.id}/invoice"

      found_invoice = JSON.parse(response.body)

      expect(response).to be_successful
      expect(found_invoice["data"].first["attributes"]["id"].to_i).to eq(@invoice.id)
    end
  end
end
