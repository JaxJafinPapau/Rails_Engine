require 'rails_helper'

RSpec.describe Customer, type: :model do
  describe "find_all" do
    it "should give all customers with no params" do
      create_list(:customer, 5)

      params = {}

      expect(Customer.find_all(params).count).to eq(5)
    end
  end

  #write tests for the full functionality of these methods

  describe "search" do
    it "should return the first customer with matching id" do
      customer = create(:customer)

      params = {id: customer.id}

      expect(Customer.search(params).id).to eq(customer.id)
    end
  end
end
