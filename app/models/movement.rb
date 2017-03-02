class Movement
  CONVENTIONAL_COSTS_PER_KM = 0.0

  include Mongoid::Document
  embedded_in :route, polymorphic: true

  field :distance, type: Integer, default: 0
  field :duration, type: Integer, default: 0

  def total_duration
    duration
  end

  def conventional_costs
    total_distance * CONVENTIONAL_COSTS_PER_KM
  end

  def total_distance
    distance
  end
end
