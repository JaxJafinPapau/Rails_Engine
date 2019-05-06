require 'rails_helper'

describe "Transactions API", type: :request do
  before :each do
    @merchant = create(:merchant)
    @customer = create(:customer)
    @invoice = create(:invoice, merchant_id: @merchant.id, customer_id: @customer.id)
    @invoice_2 = create(:invoice, merchant_id: @merchant.id, customer_id: @customer.id)
  end

  it "sends a list of transactions" do
    create_list(:transaction, 5, invoice_id: @invoice.id)

    get '/api/v1/transactions'

    expect(response).to be_successful

    transactions = JSON.parse(response.body)

    expect(transactions["data"].count).to eq(5)
  end

  it "can show one transaction" do
    transaction_resource = create(:transaction, invoice_id: @invoice.id)

    get "/api/v1/transactions/#{transaction_resource.id}"

    expect(response).to be_successful

    transaction = JSON.parse(response.body)

    expect(transaction["data"]["attributes"]["id"]).to eq(transaction_resource.id)
  end

  it "can search for a transaction based on the id" do
    transaction_1 = create(:transaction, invoice_id: @invoice.id)
    transaction_2 = create(:transaction, invoice_id: @invoice_2.id)
    transaction_3 = create(:transaction, invoice_id: @invoice_2.id)

    get "/api/v1/transactions/find?id=#{transaction_1.id}"

    found_transaction = JSON.parse(response.body)

    expect(response).to be_successful
    expect(found_transaction["data"]["attributes"]["id"]).to eq(transaction_1.id)
  end

  it "can search for a transaction based on the invoice_id" do
    transaction_1 = create(:transaction, invoice_id: @invoice.id)
    transaction_2 = create(:transaction, invoice_id: @invoice_2.id)
    transaction_3 = create(:transaction, invoice_id: @invoice_2.id)

    get "/api/v1/transactions/find?invoice_id=#{transaction_1.invoice_id}"

    found_transaction = JSON.parse(response.body)

    expect(response).to be_successful
    expect(found_transaction["data"]["attributes"]["id"]).to eq(transaction_1.id)
    expect(found_transaction["data"]["attributes"]["invoice_id"]).to eq(transaction_1.invoice_id)
  end

  it "can search for a transaction based on the credit_card_number" do
    transaction_1 = create(:transaction, credit_card_number: "12341234123412341234", invoice_id: @invoice.id)
    transaction_2 = create(:transaction, invoice_id: @invoice.id)
    transaction_3 = create(:transaction, invoice_id: @invoice.id)

    get "/api/v1/transactions/find?credit_card_number=#{transaction_1.credit_card_number}"

    found_transaction = JSON.parse(response.body)

    expect(response).to be_successful
    expect(found_transaction["data"]["attributes"]["id"]).to eq(transaction_1.id)
    expect(found_transaction["data"]["attributes"]["credit_card_number"]).to eq(transaction_1.credit_card_number)
  end

  it "can search for a transaction based on the invoice_id" do
    transaction_1 = create(:transaction, invoice_id: @invoice.id)
    not_this_invoice = @invoice_2
    transaction_2 = create(:transaction, invoice_id: not_this_invoice.id)
    transaction_3 = create(:transaction, invoice_id: not_this_invoice.id)

    get "/api/v1/transactions/find?invoice_id=#{transaction_1.invoice_id}"

    found_transaction = JSON.parse(response.body)

    expect(response).to be_successful
    expect(found_transaction["data"]["attributes"]["id"]).to eq(transaction_1.id)
    expect(found_transaction["data"]["attributes"]["invoice_id"]).to eq(transaction_1.invoice_id)
  end

  it "can search for a transaction based on created_at" do
    transaction_1 = create(:transaction, created_at: "2012-03-27T14:54:05.000Z", invoice_id: @invoice.id)
    transaction_2 = create(:transaction, invoice_id: @invoice.id)
    transaction_3 = create(:transaction, invoice_id: @invoice.id)

    # binding.pry
    get "/api/v1/transactions/find?created_at=#{transaction_1.created_at}"

    found_transaction = JSON.parse(response.body)

    expect(found_transaction["data"]["attributes"]["id"]).to eq(transaction_1.id)
    expect(found_transaction["data"]["attributes"]["credit_card_number"]).to eq(transaction_1.credit_card_number)
  end

  it "can search for a transaction based on updated_at" do
    transaction_1 = create(:transaction, created_at: "2012-03-27T14:54:05.000Z", updated_at: "2013-03-27T14:54:05.000Z", invoice_id: @invoice.id)
    transaction_2 = create(:transaction, invoice_id: @invoice.id)
    transaction_3 = create(:transaction, invoice_id: @invoice.id)

    get "/api/v1/transactions/find?updated_at=#{transaction_1.updated_at}"

    found_transaction = JSON.parse(response.body)

    expect(found_transaction["data"]["attributes"]["id"]).to eq(transaction_1.id)
    expect(found_transaction["data"]["attributes"]["credit_card_number"]).to eq(transaction_1.credit_card_number)
  end

  it "can search for all transactions based on the id" do
    transaction_1 = create(:transaction, invoice_id: @invoice.id)
    transaction_2 = create(:transaction, invoice_id: @invoice.id)
    transaction_3 = create(:transaction, invoice_id: @invoice.id)

    get "/api/v1/transactions/find_all?id=#{transaction_1.id}"

    found_transactions = JSON.parse(response.body)

    expect(response).to be_successful
    expect(found_transactions["data"]).to be_an(Array)
    expect(found_transactions["data"].first["id"].to_i).to eq(transaction_1.id)
  end

  it "can find_all transactions by invoice_id and return a serialized array" do
    transaction_1 = create(:transaction, invoice_id: @invoice.id)
    transaction_2 = create(:transaction, invoice_id: @invoice.id)
    transaction_3 = create(:transaction, invoice_id: @invoice_2.id)

    get "/api/v1/transactions/find_all?invoice_id=#{transaction_1.invoice_id}"

    found_transactions = JSON.parse(response.body)

    expect(response).to be_successful
    expect(found_transactions["data"].count).to eq(2)
    expect(found_transactions["data"]).to be_an(Array)
    expect(found_transactions["data"].first["attributes"]["invoice_id"]).to eq(transaction_1.invoice_id)
  end

  it "can find_all transactions by credit_card_number and return a serialized array" do
    transaction_1 = create(:transaction, credit_card_number: "12341234123412341234", invoice_id: @invoice.id)
    transaction_2 = create(:transaction, credit_card_number: "12341234123412341234", invoice_id: @invoice.id)
    transaction_3 = create(:transaction, invoice_id: @invoice.id)

    get "/api/v1/transactions/find_all?credit_card_number=#{transaction_1.credit_card_number}"

    found_transactions = JSON.parse(response.body)

    expect(response).to be_successful
    expect(found_transactions["data"].count).to eq(2)
    expect(found_transactions["data"]).to be_an(Array)
    expect(found_transactions["data"].first["attributes"]["credit_card_number"]).to eq(transaction_1.credit_card_number)
  end

  it "can find_all transactions by invoice_id and return a serialized array" do
    transaction_1 = create(:transaction, invoice_id: @invoice.id)
    transaction_2 = create(:transaction, invoice_id: @invoice.id)
    other_invoice = @invoice_2
    transaction_3 = create(:transaction, invoice_id: other_invoice.id)

    get "/api/v1/transactions/find_all?invoice_id=#{transaction_1.invoice_id}"

    found_transactions = JSON.parse(response.body)

    expect(response).to be_successful
    expect(found_transactions["data"].count).to eq(2)
    expect(found_transactions["data"]).to be_an(Array)
    expect(found_transactions["data"].first["attributes"]["invoice_id"]).to eq(transaction_1.invoice_id)
  end

  it "can find_all transactions by created_at and return a serialized array" do
    transaction_1 = create(:transaction, invoice_id: @invoice.id, created_at: "2012-03-27T14:54:05.000Z")
    transaction_2 = create(:transaction, invoice_id: @invoice.id, created_at: "2012-03-27T14:54:05.000Z")
    transaction_3 = create(:transaction, invoice_id: @invoice.id, created_at: "2014-05-29T14:54:05.000Z")

    get "/api/v1/transactions/find_all?created_at=#{transaction_1.created_at}"

    found_transactions = JSON.parse(response.body)

    expect(response).to be_successful
    expect(found_transactions["data"].count).to eq(2)
    expect(found_transactions["data"]).to be_an(Array)
    expect(found_transactions["data"].first["attributes"]["id"]).to eq(transaction_1.id)
  end

  it "can find_all transactions by updated_at and return a serialized array" do
    transaction_1 = create(:transaction, invoice_id: @invoice.id, updated_at: "2013-03-27T14:54:05.000Z", created_at: "2012-03-27T14:54:05.000Z")
    transaction_2 = create(:transaction, invoice_id: @invoice.id, updated_at: "2013-03-27T14:54:05.000Z", created_at: "2012-03-27T14:54:05.000Z")
    transaction_3 = create(:transaction, invoice_id: @invoice.id, updated_at: "2015-05-29T14:54:05.000Z", created_at: "2012-03-27T14:54:05.000Z")

    get "/api/v1/transactions/find_all?updated_at=#{transaction_1.updated_at}"

    found_transactions = JSON.parse(response.body)

    expect(response).to be_successful
    expect(found_transactions["data"].count).to eq(2)
    expect(found_transactions["data"]).to be_an(Array)
    expect(found_transactions["data"].first["attributes"]["id"]).to eq(transaction_1.id)
  end

  describe "relational endpoints" do
    it "can return its invoice" do
      transaction_1 = create(:transaction, invoice_id: @invoice.id)

      get "/api/v1/transactions/#{transaction_1.id}/invoice"

      found_invoice = JSON.parse(response.body)
      expect(response).to be_successful
      expect(found_invoice["data"].first["attributes"]["id"]).to eq(@invoice.id)
    end
  end
end
