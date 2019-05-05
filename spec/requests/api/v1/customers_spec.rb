require 'rails_helper'

describe 'Customers API' do
  it "sends a list of customers" do
    create_list(:customer, 5)

    get '/api/v1/customers'

    expect(response).to be_successful

    customers = JSON.parse(response.body)

    expect(customers["data"].count).to eq(5)
  end

  it "can show one customer" do
    id = create(:customer).id

    get "/api/v1/customers/#{id}"

    customer = JSON.parse(response.body)

    expect(response).to be_successful
    expect(customer["data"]["attributes"]["id"]).to eq(id)
  end

  it "can search for a customer based on the id" do
    customer = create(:customer, first_name: "Mike")
    customer_two = create(:customer)
    customer_three = create(:customer)

    get "/api/v1/customers/find?id=#{customer.id}"

    found_customer = JSON.parse(response.body)

    expect(response).to be_successful
    expect(found_customer["data"]["attributes"]["id"]).to eq(customer.id)
    expect(found_customer["data"]["attributes"]["first_name"]).to eq(customer.first_name)
  end

  it "can search for a customer based on the first_name" do
    customer = create(:customer, first_name: "Mike")
    customer_two = create(:customer)
    customer_three = create(:customer)

    get "/api/v1/customers/find?first_name=#{customer.first_name}"

    found_customer = JSON.parse(response.body)

    expect(found_customer["data"]["attributes"]["id"]).to eq(customer.id)
    expect(found_customer["data"]["attributes"]["first_name"]).to eq(customer.first_name)
  end

  it "can search for a customer based on the last_name" do
    customer = create(:customer, last_name: "Dao")
    customer_two = create(:customer)
    customer_three = create(:customer)

    get "/api/v1/customers/find?last_name=#{customer.last_name}"

    found_customer = JSON.parse(response.body)

    expect(found_customer["data"]["attributes"]["id"]).to eq(customer.id)
    expect(found_customer["data"]["attributes"]["last_name"]).to eq(customer.last_name)
  end

  it "can search for a customer by created_at" do
    customer = create(:customer, first_name: "Josh", created_at: "2012-03-27T14:56:04.000Z")
    customer_two = create(:customer)
    customer_three = create(:customer)

    get "/api/v1/customers/find?created_at=#{customer.created_at}"

    found_customer = JSON.parse(response.body)

    expect(found_customer["data"]["attributes"]["id"]).to eq(customer.id)
    expect(found_customer["data"]["attributes"]["first_name"]).to eq(customer.first_name)
  end

  it "can search for a customer by updated_at" do
    customer = create(:customer, last_name: "Mejia", updated_at: "2012-03-27T14:54:02.000Z")
    customer_two = create(:customer)

    get "/api/v1/customers/find?updated_at=#{customer.updated_at}"

    found_customer = JSON.parse(response.body)

    expect(found_customer["data"]["attributes"]["id"]).to eq(customer.id)
    expect(found_customer["data"]["attributes"]["last_name"]).to eq(customer.last_name)
  end

  it "can find_all customers by id and return an array" do
    customer_1 = create(:customer, first_name: "Jeremy")
    customer_2 = create(:customer)

    get "/api/v1/customers/find_all?id=#{customer_1.id}"


    found_customers = JSON.parse(response.body)

    expect(response).to be_successful
    expect(found_customers["data"]).to be_an(Array)
    expect(found_customers["data"].first["id"].to_i).to eq(customer_1.id)
  end

  it "can find_all customers by first_name and return a serialized array" do
    customer_1 = create(:customer, first_name: "Jeremy")
    customer_1 = create(:customer, first_name: "Jeremy")
    customer_2 = create(:customer)

    get "/api/v1/customers/find_all?first_name=#{customer_1.first_name}"

    found_customers = JSON.parse(response.body)

    expect(response).to be_successful
    expect(found_customers["data"]).to be_an(Array)
    expect(found_customers["data"].count).to eq(2)
    expect(found_customers["data"].first["attributes"]["first_name"]).to eq(customer_1.first_name)
  end

  it "can find_all customers by last_name and return a serialized array" do
    customer_1 = create(:customer, last_name: "Bennett")
    customer_1 = create(:customer, last_name: "Bennett")
    customer_2 = create(:customer)

    get "/api/v1/customers/find_all?last_name=#{customer_1.last_name}"

    found_customers = JSON.parse(response.body)

    expect(response).to be_successful
    expect(found_customers["data"]).to be_an(Array)
    expect(found_customers["data"].count).to eq(2)
    expect(found_customers["data"].first["attributes"]["last_name"]).to eq(customer_1.last_name)
  end
end
