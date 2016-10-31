class Car
  include Mongoid::Document
  include Mongoid::Timestamps

  embedded_in :subject

  field :category, type: String
  field :type_of_power, type: String

  validates :category, presence: true
  validates :type_of_power, presence: true
end
