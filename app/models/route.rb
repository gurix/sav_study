class Route
  include Mongoid::Document
  include Mongoid::Timestamps

  embedded_in :subject

  field :description, type: String
end
