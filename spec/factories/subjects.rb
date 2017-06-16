FactoryGirl.define do
  factory :subject do
    gender { %w(m f).sample }
  end
end
