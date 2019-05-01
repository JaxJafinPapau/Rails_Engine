FactoryBot.define do
  factory :merchant do
    name { "Merchant Name" }
    created_at { DateTime.now.strftime("%Y-%m-%d %H:%M:%S UTC")}
    # created_at { Time.now.utc }
  end
end
