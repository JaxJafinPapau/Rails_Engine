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
end
