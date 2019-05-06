require 'rails_helper'

describe 'Merchants API' do
  it "sends a list of merchants" do
    create_list(:merchant, 5)

    get '/api/v1/merchants'

    expect(response).to be_successful

    merchants = JSON.parse(response.body)

    expect(merchants["data"].count).to eq(5)
  end

  it "can show one merchant" do
    id = create(:merchant).id

    get "/api/v1/merchants/#{id}"

    merchant = JSON.parse(response.body)

    expect(response).to be_successful
    expect(merchant["data"]["attributes"]["id"]).to eq(id)
  end

  it "can search for a merchant based on the id" do
    merchant = create(:merchant, name: "Mike Dao")
    merchant_two = create(:merchant)
    merchant_three = create(:merchant)

    get "/api/v1/merchants/find?id=#{merchant.id}"

    found_merchant = JSON.parse(response.body)

    expect(response).to be_successful
    expect(found_merchant["data"]["attributes"]["id"]).to eq(merchant.id)
    expect(found_merchant["data"]["attributes"]["name"]).to eq(merchant.name)
  end

  it "can search for a merchant based on the name" do
    merchant = create(:merchant, name: "Mike Dao")
    merchant_two = create(:merchant)
    merchant_three = create(:merchant)

    get "/api/v1/merchants/find?name=#{merchant.name}"

    found_merchant = JSON.parse(response.body)

    expect(found_merchant["data"]["attributes"]["id"]).to eq(merchant.id)
    expect(found_merchant["data"]["attributes"]["name"]).to eq(merchant.name)
  end

  it "can search for a merchant by created_at" do
    merchant = create(:merchant, name: "Josh Mejia")
    merchant_two = create(:merchant)
    merchant_three = create(:merchant)

    get "/api/v1/merchants/find?created_at=#{merchant.created_at}"

    found_merchant = JSON.parse(response.body)

    expect(found_merchant["data"]["attributes"]["id"]).to eq(merchant.id)
    expect(found_merchant["data"]["attributes"]["name"]).to eq(merchant.name)
  end

  it "can search for a merchant by updated_at" do
    merchant = create(:merchant, name: "Josh Mejia", updated_at: "2012-03-27T14:54:02.000Z")
    merchant_two = create(:merchant)

    get "/api/v1/merchants/find?updated_at=#{merchant.updated_at}"

    found_merchant = JSON.parse(response.body)

    expect(found_merchant["data"]["attributes"]["id"]).to eq(merchant.id)
    expect(found_merchant["data"]["attributes"]["name"]).to eq(merchant.name)
  end

  it "can find_all merchants by id and return an array" do
    merchant_1 = create(:merchant, name: "Jeremy Bennett")
    merchant_2 = create(:merchant)

    get "/api/v1/merchants/find_all?id=#{merchant_1.id}"


    found_merchants = JSON.parse(response.body)

    expect(response).to be_successful
    expect(found_merchants["data"]).to be_an(Array)
    expect(found_merchants["data"].first["id"].to_i).to eq(merchant_1.id)
  end

  it "can find_all merchants by name and return a serialized array" do
    merchant_1 = create(:merchant, name: "Jeremy Bennett")
    merchant_1 = create(:merchant, name: "Jeremy Bennett")
    merchant_2 = create(:merchant)

    get "/api/v1/merchants/find_all?name=#{merchant_1.name}"

    found_merchants = JSON.parse(response.body)

    expect(response).to be_successful
    expect(found_merchants["data"]).to be_an(Array)
    expect(found_merchants["data"].count).to eq(2)
    expect(found_merchants["data"].first["attributes"]["name"]).to eq(merchant_1.name)
  end


  context 'relational endpoints' do
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
    it "should have items" do

      get "/api/v1/merchants/#{@merchant.id}/items"

      expect(response).to be_successful

      items = JSON.parse(response.body)

      expect(items["data"].first["attributes"]["id"].to_i).to eq(@item.id)
    end

    it "should have invoices" do
      get "/api/v1/merchants/#{@merchant.id}/invoices"

      expect(response).to be_successful

      invoices = JSON.parse(response.body)

      expect(invoices["data"].first["attributes"]["id"].to_i).to eq(@invoice.id)
    end
  end
  # it "can create a merchant" do
  #   merchant_params = {name: "Mike Dao"}
  #
  #   post "/api/v1/merchants", params: {merchant: merchant_params}
  #   merchant = Merchant.last
  #
  #   expect(response).to be_successful
  #   expect(merchant.name).to eq(merchant_params[:name])
  # end

  # it "can update a merchant" do
  #   id = create(:merchant).id
  #   previous_name = Merchant.last.name
  #   merchant_params = {name: "Mike Dao"}
  #
  #   put "/api/v1/merchants/#{id}", params: {merchant: merchant_params}
  #   merchant = Merchant.find(id)
  #
  #   expect(response).to be_successful
  #   expect(merchant.name).to_not eq(previous_name)
  #   expect(merchant.name).to eq("Mike Dao")
  # end

  # it "can delete a merchant" do
  #   merchant = create(:merchant)
  #
  #   expect(Merchant.count).to eq(1)
  #
  #   delete "/api/v1/merchants/#{merchant.id}"
  #
  #   expect(response).to be_successful
  #   expect(Merchant.count).to eq(0)
  #   expect{Merchant.find(merchant.id)}.to raise_error(ActiveRecord::RecordNotFound)
  # end

end
