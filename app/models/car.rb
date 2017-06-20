class Car
  include Mongoid::Document
  include Mongoid::Timestamps

  embedded_in :subject

  field :car_owner,     type: Boolean
  field :is_commuter,   type: Boolean
  field :category,      type: String
  field :type_of_power, type: String

  validates :car_owner,     presence: true
  validates :is_commuter,   presence: true
  validates :category,      presence: true, if: proc { |car| car.car_owner == true }
  validates :type_of_power, presence: true, if: proc { |car| car.car_owner == true }
end
