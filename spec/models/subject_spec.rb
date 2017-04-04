require 'rails_helper'

RSpec.describe Subject do
  it { expect(subject).to validate_uniqueness_of(:token) }

  it 'generates a view token automatically' do
    subject = create :subject
    expect(subject.token).not_to be_empty
  end

  it { expect(subject).to embed_many(:routes) }
  it { expect(subject).to embed_one(:car) }
end
