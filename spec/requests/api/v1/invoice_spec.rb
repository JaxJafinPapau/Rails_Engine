require 'rails_helper'

describe "Invoices API", type: :request do
  before :each do
    @merchant = create(:merchant)
    @merchant_2 = create(:merchant)
    @customer = create(:customer)
    @customer_2 = create(:customer)
    @invoice = create(:invoice, merchant_id: @merchant.id, customer_id: @customer.id)
    @invoice_2 = create(:invoice, merchant_id: @merchant_2.id, customer_id: @customer_2.id)
    @invoice_3 = create(:invoice, merchant_id: @merchant_2.id, customer_id: @customer_2.id)
  end

  it "sends a list of invoices" do
    create_list(:invoice, 5, invoice_id: @invoice.id)

    get '/api/v1/invoices'

    expect(response).to be_successful

    invoices = JSON.parse(response.body)

    expect(invoices["data"].count).to eq(5)
  end

  it "can show one invoice" do
    invoice_resource = create(:invoice, invoice_id: @invoice.id)

    get "/api/v1/invoices/#{invoice_resource.id}"

    expect(response).to be_successful

    invoice = JSON.parse(response.body)

    expect(invoice["data"]["attributes"]["id"]).to eq(invoice_resource.id)
  end

  it "can search for a invoice based on the id" do
    invoice_1 = create(:invoice, invoice_id: @invoice.id)
    invoice_2 = create(:invoice, invoice_id: @invoice_2.id)
    invoice_3 = create(:invoice, invoice_id: @invoice_2.id)

    get "/api/v1/invoices/find?id=#{@invoice_1.id}"

    found_invoice = JSON.parse(response.body)

    expect(response).to be_successful
    expect(found_invoice["data"]["attributes"]["id"]).to eq(@invoice_1.id)
  end

  it "can search for a invoice based on the invoice_id" do
    invoice_1 = create(:invoice, invoice_id: @invoice.id)
    invoice_2 = create(:invoice, invoice_id: @invoice_2.id)
    invoice_3 = create(:invoice, invoice_id: @invoice_2.id)

    get "/api/v1/invoices/find?invoice_id=#{@invoice_1.invoice_id}"

    found_invoice = JSON.parse(response.body)

    expect(response).to be_successful
    expect(found_invoice["data"]["attributes"]["id"]).to eq(@invoice_1.id)
    expect(found_invoice["data"]["attributes"]["invoice_id"]).to eq(@invoice_1.invoice_id)
  end

  it "can search for a invoice based on the credit_card_number" do
    invoice_1 = create(:invoice, credit_card_number: "12341234123412341234", invoice_id: @invoice.id)
    invoice_2 = create(:invoice, invoice_id: @invoice.id)
    invoice_3 = create(:invoice, invoice_id: @invoice.id)

    get "/api/v1/invoices/find?credit_card_number=#{@invoice_1.credit_card_number}"

    found_invoice = JSON.parse(response.body)

    expect(response).to be_successful
    expect(found_invoice["data"]["attributes"]["id"]).to eq(@invoice_1.id)
    expect(found_invoice["data"]["attributes"]["credit_card_number"]).to eq(@invoice_1.credit_card_number)
  end

  it "can search for a invoice based on the invoice_id" do
    invoice_1 = create(:invoice, invoice_id: @invoice.id)
    not_this_invoice = @invoice_2
    invoice_2 = create(:invoice, invoice_id: not_this_invoice.id)
    invoice_3 = create(:invoice, invoice_id: not_this_invoice.id)

    get "/api/v1/invoices/find?invoice_id=#{@invoice_1.invoice_id}"

    found_invoice = JSON.parse(response.body)

    expect(response).to be_successful
    expect(found_invoice["data"]["attributes"]["id"]).to eq(@invoice_1.id)
    expect(found_invoice["data"]["attributes"]["invoice_id"]).to eq(@invoice_1.invoice_id)
  end

  it "can search for a invoice based on created_at" do
    invoice_1 = create(:invoice, created_at: "2012-03-27T14:54:05.000Z", invoice_id: @invoice.id)
    invoice_2 = create(:invoice, invoice_id: @invoice.id)
    invoice_3 = create(:invoice, invoice_id: @invoice.id)

    # binding.pry
    get "/api/v1/invoices/find?created_at=#{@invoice_1.created_at}"

    found_invoice = JSON.parse(response.body)

    expect(found_invoice["data"]["attributes"]["id"]).to eq(@invoice_1.id)
    expect(found_invoice["data"]["attributes"]["credit_card_number"]).to eq(@invoice_1.credit_card_number)
  end

  it "can search for a invoice based on updated_at" do
    invoice_1 = create(:invoice, created_at: "2012-03-27T14:54:05.000Z", updated_at: "2013-03-27T14:54:05.000Z", invoice_id: @invoice.id)
    invoice_2 = create(:invoice, invoice_id: @invoice.id)
    invoice_3 = create(:invoice, invoice_id: @invoice.id)

    get "/api/v1/invoices/find?updated_at=#{@invoice_1.updated_at}"

    found_invoice = JSON.parse(response.body)

    expect(found_invoice["data"]["attributes"]["id"]).to eq(@invoice_1.id)
    expect(found_invoice["data"]["attributes"]["credit_card_number"]).to eq(@invoice_1.credit_card_number)
  end

  it "can search for all invoices based on the id" do
    invoice_1 = create(:invoice, invoice_id: @invoice.id)
    invoice_2 = create(:invoice, invoice_id: @invoice.id)
    invoice_3 = create(:invoice, invoice_id: @invoice.id)

    get "/api/v1/invoices/find_all?id=#{@invoice_1.id}"

    found_invoices = JSON.parse(response.body)

    expect(response).to be_successful
    expect(found_invoices["data"]).to be_an(Array)
    expect(found_invoices["data"].first["id"].to_i).to eq(@invoice_1.id)
  end

  it "can find_all invoices by invoice_id and return a serialized array" do
    invoice_1 = create(:invoice, invoice_id: @invoice.id)
    invoice_2 = create(:invoice, invoice_id: @invoice.id)
    invoice_3 = create(:invoice, invoice_id: @invoice_2.id)

    get "/api/v1/invoices/find_all?invoice_id=#{@invoice_1.invoice_id}"

    found_invoices = JSON.parse(response.body)

    expect(response).to be_successful
    expect(found_invoices["data"].count).to eq(2)
    expect(found_invoices["data"]).to be_an(Array)
    expect(found_invoices["data"].first["attributes"]["invoice_id"]).to eq(@invoice_1.invoice_id)
  end

  it "can find_all invoices by credit_card_number and return a serialized array" do
    invoice_1 = create(:invoice, credit_card_number: "12341234123412341234", invoice_id: @invoice.id)
    invoice_2 = create(:invoice, credit_card_number: "12341234123412341234", invoice_id: @invoice.id)
    invoice_3 = create(:invoice, invoice_id: @invoice.id)

    get "/api/v1/invoices/find_all?credit_card_number=#{@invoice_1.credit_card_number}"

    found_invoices = JSON.parse(response.body)

    expect(response).to be_successful
    expect(found_invoices["data"].count).to eq(2)
    expect(found_invoices["data"]).to be_an(Array)
    expect(found_invoices["data"].first["attributes"]["credit_card_number"]).to eq(@invoice_1.credit_card_number)
  end

  it "can find_all invoices by invoice_id and return a serialized array" do
    invoice_1 = create(:invoice, invoice_id: @invoice.id)
    invoice_2 = create(:invoice, invoice_id: @invoice.id)
    other_invoice = @invoice_2
    invoice_3 = create(:invoice, invoice_id: other_invoice.id)

    get "/api/v1/invoices/find_all?invoice_id=#{@invoice_1.invoice_id}"

    found_invoices = JSON.parse(response.body)

    expect(response).to be_successful
    expect(found_invoices["data"].count).to eq(2)
    expect(found_invoices["data"]).to be_an(Array)
    expect(found_invoices["data"].first["attributes"]["invoice_id"]).to eq(@invoice_1.invoice_id)
  end

  it "can find_all invoices by created_at and return a serialized array" do
    invoice_1 = create(:invoice, invoice_id: @invoice.id, created_at: "2012-03-27T14:54:05.000Z")
    invoice_2 = create(:invoice, invoice_id: @invoice.id, created_at: "2012-03-27T14:54:05.000Z")
    invoice_3 = create(:invoice, invoice_id: @invoice.id, created_at: "2014-05-29T14:54:05.000Z")

    get "/api/v1/invoices/find_all?created_at=#{@invoice_1.created_at}"

    found_invoices = JSON.parse(response.body)

    expect(response).to be_successful
    expect(found_invoices["data"].count).to eq(2)
    expect(found_invoices["data"]).to be_an(Array)
    expect(found_invoices["data"].first["attributes"]["id"]).to eq(@invoice_1.id)
  end

  it "can find_all invoices by updated_at and return a serialized array" do
    invoice_1 = create(:invoice, invoice_id: @invoice.id, updated_at: "2013-03-27T14:54:05.000Z", created_at: "2012-03-27T14:54:05.000Z")
    invoice_2 = create(:invoice, invoice_id: @invoice.id, updated_at: "2013-03-27T14:54:05.000Z", created_at: "2012-03-27T14:54:05.000Z")
    invoice_3 = create(:invoice, invoice_id: @invoice.id, updated_at: "2015-05-29T14:54:05.000Z", created_at: "2012-03-27T14:54:05.000Z")

    get "/api/v1/invoices/find_all?updated_at=#{@invoice_1.updated_at}"

    found_invoices = JSON.parse(response.body)

    expect(response).to be_successful
    expect(found_invoices["data"].count).to eq(2)
    expect(found_invoices["data"]).to be_an(Array)
    expect(found_invoices["data"].first["attributes"]["id"]).to eq(@invoice_1.id)
  end
end
