FactoryGirl.define do
  factory :subject do
    email { Faker::Internet.email }
    gender { %w(m f).sample }
  end
end
