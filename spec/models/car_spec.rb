require 'rails_helper'

RSpec.describe Car do
  it { expect(subject).to validate_presence_of(:car_owner) }
  it { expect(subject).to validate_presence_of(:is_commuter) }
  it { expect(subject).to validate_presence_of(:category) }
  it { expect(subject).to validate_presence_of(:type_of_power) }

  it { expect(subject).to be_embedded_in(:subject) }
end
