require 'rails_helper'

describe "Invoices API", type: :request do
  before :each do
    @merchant = create(:merchant)
    @merchant_2 = create(:merchant)
    @customer = create(:customer)
    @customer_2 = create(:customer)
    @invoice = create(:invoice, merchant_id: @merchant.id, customer_id: @customer.id)
    @invoice_2 = create(:invoice, merchant_id: @merchant_2.id, customer_id: @customer_2.id, status: "shipped", created_at: "2012-03-09T08:57:21.000Z", updated_at: "2013-03-09T08:57:21.000Z")
    @invoice_3 = create(:invoice, merchant_id: @merchant_2.id, customer_id: @customer_2.id, status: "shipped", created_at: "2012-03-09T08:57:21.000Z", updated_at: "2013-03-09T08:57:21.000Z")
  end

  it "sends a list of invoices" do
    get '/api/v1/invoices'

    expect(response).to be_successful

    invoices = JSON.parse(response.body)

    expect(invoices["data"].count).to eq(3)
  end

  it "can show one invoice" do
    get "/api/v1/invoices/#{@invoice.id}"

    expect(response).to be_successful

    invoice = JSON.parse(response.body)

    expect(invoice["data"]["attributes"]["id"]).to eq(@invoice.id)
  end

  it "can search for a invoice based on the id" do
    get "/api/v1/invoices/find?id=#{@invoice.id}"

    found_invoice = JSON.parse(response.body)

    expect(response).to be_successful
    expect(found_invoice["data"]["attributes"]["id"]).to eq(@invoice.id)
  end

  it "can search for a invoice based on the customer_id" do
    get "/api/v1/invoices/find?customer_id=#{@invoice.customer_id}"

    found_invoice = JSON.parse(response.body)

    expect(response).to be_successful
    expect(found_invoice["data"]["attributes"]["id"]).to eq(@invoice.id)
    expect(found_invoice["data"]["attributes"]["customer_id"]).to eq(@invoice.customer_id)
  end

  it "can search for a invoice based on the merchant_id" do
    get "/api/v1/invoices/find?merchant_id=#{@invoice.merchant_id}"

    found_invoice = JSON.parse(response.body)

    expect(response).to be_successful
    expect(found_invoice["data"]["attributes"]["id"]).to eq(@invoice.id)
    expect(found_invoice["data"]["attributes"]["merchant_id"]).to eq(@invoice.merchant_id)
  end

  it "can search for a invoice based on the status" do
    get "/api/v1/invoices/find?status=#{@invoice.status}"

    found_invoice = JSON.parse(response.body)

    expect(response).to be_successful
    expect(found_invoice["data"]["attributes"]["id"]).to eq(@invoice.id)
    expect(found_invoice["data"]["attributes"]["status"]).to eq(@invoice.status)
  end

  it "can search for a invoice based on created_at" do
    invoice_1 = create(:invoice, created_at: "2012-03-27T14:54:05.000Z", merchant_id: @merchant.id, customer_id: @customer.id)

    get "/api/v1/invoices/find?created_at=#{invoice_1.created_at}"

    found_invoice = JSON.parse(response.body)

    expect(found_invoice["data"]["attributes"]["id"]).to eq(invoice_1.id)
    expect(found_invoice["data"]["attributes"]["status"]).to eq(invoice_1.status)
  end

  it "can search for a invoice based on updated_at" do
    invoice_1 = create(:invoice, created_at: "2012-03-27T14:54:05.000Z", updated_at: "2013-03-27T14:54:05.000Z", merchant_id: @merchant.id, customer_id: @customer.id)

    get "/api/v1/invoices/find?updated_at=#{invoice_1.updated_at}"

    found_invoice = JSON.parse(response.body)

    expect(found_invoice["data"]["attributes"]["id"]).to eq(invoice_1.id)
    expect(found_invoice["data"]["attributes"]["status"]).to eq(invoice_1.status)
  end

  it "can search for all invoices based on the id" do
    get "/api/v1/invoices/find_all?id=#{@invoice_2.id}"

    found_invoices = JSON.parse(response.body)

    expect(response).to be_successful
    expect(found_invoices["data"]).to be_an(Array)
    expect(found_invoices["data"].first["id"].to_i).to eq(@invoice_2.id)
  end

  it "can find_all invoices by customer_id and return a serialized array" do
    get "/api/v1/invoices/find_all?customer_id=#{@invoice_2.customer_id}"

    found_invoices = JSON.parse(response.body)

    expect(response).to be_successful
    expect(found_invoices["data"].count).to eq(2)
    expect(found_invoices["data"]).to be_an(Array)
    expect(found_invoices["data"].first["attributes"]["customer_id"]).to eq(@invoice_2.customer_id)
  end

  it "can find_all invoices by merchant_id and return a serialized array" do
    get "/api/v1/invoices/find_all?merchant_id=#{@invoice_2.merchant_id}"

    found_invoices = JSON.parse(response.body)

    expect(response).to be_successful
    expect(found_invoices["data"].count).to eq(2)
    expect(found_invoices["data"]).to be_an(Array)
    expect(found_invoices["data"].first["attributes"]["merchant_id"]).to eq(@invoice_2.merchant_id)
  end

  it "can find_all invoices by status and return a serialized array" do
    get "/api/v1/invoices/find_all?status=#{@invoice_2.status}"

    found_invoices = JSON.parse(response.body)

    expect(response).to be_successful
    expect(found_invoices["data"].count).to eq(2)
    expect(found_invoices["data"]).to be_an(Array)
    expect(found_invoices["data"].first["attributes"]["status"]).to eq(@invoice_2.status)
  end

  it "can find_all invoices by created_at and return a serialized array" do
    get "/api/v1/invoices/find_all?created_at=#{@invoice_2.created_at}"

    found_invoices = JSON.parse(response.body)

    expect(response).to be_successful
    expect(found_invoices["data"].count).to eq(2)
    expect(found_invoices["data"]).to be_an(Array)
    expect(found_invoices["data"].first["attributes"]["id"]).to eq(@invoice_2.id)
  end

  it "can find_all invoices by updated_at and return a serialized array" do
    get "/api/v1/invoices/find_all?updated_at=#{@invoice_2.updated_at}"

    found_invoices = JSON.parse(response.body)

    expect(response).to be_successful
    expect(found_invoices["data"].count).to eq(2)
    expect(found_invoices["data"]).to be_an(Array)
    expect(found_invoices["data"].first["attributes"]["id"]).to eq(@invoice_2.id)
  end

  context 'relational endpoints' do
    before :each do
      @relational_merchant = create(:merchant)
      @relational_merchant_2 = create(:merchant)
      @relational_customer = create(:customer)
      @relational_customer_2 = create(:customer)
      @relational_item = create(:item, merchant_id: @relational_merchant.id)
      @relational_item_2 = create(:item, merchant_id: @relational_merchant_2.id)
      @relational_invoice = create(:invoice, merchant_id: @relational_merchant.id, customer_id: @relational_customer.id)
      @relational_invoice_2 = create(:invoice, merchant_id: @relational_merchant_2.id, customer_id: @relational_customer_2.id, status: "shipped", created_at: "2012-03-09T08:57:21.000Z", updated_at: "2013-03-09T08:57:21.000Z")
      @relational_invoice_item = create(:invoice_item, item_id: @relational_item.id, invoice_id: @relational_invoice.id)
      @relational_invoice_item_2 = create(:invoice_item, item_id: @relational_item_2.id, invoice_id: @relational_invoice_2.id, quantity: 2, created_at: "2012-03-09T08:57:21.000Z", updated_at: "2013-03-09T08:57:21.000Z")
      @relational_invoice_item_3 = create(:invoice_item, item_id: @relational_item_2.id, invoice_id: @relational_invoice_2.id, quantity: 2, created_at: "2012-03-09T08:57:21.000Z", updated_at: "2013-03-09T08:57:21.000Z")
      @relational_transaction = create(:transaction, invoice_id: @relational_invoice.id)
      @relational_transaction_2 = create(:transaction, invoice_id: @relational_invoice_2.id)
      @relational_transaction_3 = create(:transaction, invoice_id: @relational_invoice_2.id)
    end
    it "should have items" do

      get "/api/v1/invoices/#{@relational_invoice.id}/items"

      expect(response).to be_successful

      items = JSON.parse(response.body)

      expect(items["data"].first["attributes"]["id"].to_i).to eq(@relational_item.id)
    end

    it "should have invoice_items" do
      get "/api/v1/invoices/#{@relational_invoice.id}/invoice_items"

      expect(response).to be_successful

      invoice_items = JSON.parse(response.body)

      expect(invoice_items["data"].first["attributes"]["id"].to_i).to eq(@relational_invoice_item.id)
    end

    it "should have transactions" do
      get "/api/v1/invoices/#{@relational_invoice.id}/transactions"

      expect(response).to be_successful

      transactions = JSON.parse(response.body)

      expect(transactions["data"].first["attributes"]["id"].to_i).to eq(@relational_transaction.id)
    end

    it "should have customer" do
      get "/api/v1/invoices/#{@relational_invoice.id}/customer"

      expect(response).to be_successful

      customers = JSON.parse(response.body)

      expect(customers["data"].first["attributes"]["id"].to_i).to eq(@relational_customer.id)
    end

    it "should have merchants" do
      get "/api/v1/invoices/#{@relational_invoice.id}/merchant"

      expect(response).to be_successful

      merchants = JSON.parse(response.body)

      expect(merchants["data"].first["attributes"]["id"].to_i).to eq(@relational_merchant.id)
    end
  end
end
