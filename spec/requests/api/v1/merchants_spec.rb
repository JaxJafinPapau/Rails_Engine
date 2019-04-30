require 'rails_helper'

describe 'Merchants API' do
  it "sends a list of merchants" do
    create_list(:merchant, 5)

    get '/api/v1/merchants'

    expect(response).to be_successful

    merchants = JSON.parse(response.body)

    expect(merchants.count).to eq(5)
  end

  it "can show one merchant" do
    id = create(:merchant).id

    get "/api/v1/merchants/#{id}"

    merchant = JSON.parse(response.body)

    expect(response).to be_successful
    expect(merchant["id"]).to eq(id)
  end

  it "can create a merchant" do
    merchant_params = {name: "Mike Dao"}

    post "/api/v1/merchants", params: {merchant: merchant_params}
    merchant = Merchant.last

    expect(response).to be_successful
    expect(merchant.name).to eq(merchant_params[:name])
  end

  it "can update a merchant" do
    id = create(:merchant).id
    previous_name = Merchant.last.name
    merchant_params = {name: "Mike Dao"}

    put "/api/v1/merchants/#{id}", params: {merchant: merchant_params}
    merchant = Merchant.find(id)

    expect(response).to be_successful
    expect(merchant.name).to_not eq(previous_name)
    expect(merchant.name).to eq("Mike Dao")
  end

  it "can delete a merchant" do
    merchant = create(:merchant)

    expect(Merchant.count).to eq(1)

    delete "/api/v1/merchants/#{merchant.id}"

    expect(response).to be_successful
    expect(Merchant.count).to eq(0)
    expect{Merchant.find(merchant.id)}.to raise_error(ActiveRecord::RecordNotFound)
  end

  it "can search for a merchant based on the id" do
    merchant = create(:merchant, name: "Mike Dao")
    merchant_two = create(:merchant)
    merchant_three = create(:merchant)

    get "/api/v1/merchants/find?id=#{merchant.id}"

    found_merchant = JSON.parse(response.body)

    expect(found_merchant["id"]).to eq(merchant.id)
    expect(found_merchant["name"]).to eq(merchant.name)
  end
end
