class Movement
  include Mongoid::Document
  embedded_in :route, polymorphic: true

  field :distance, type: Integer, default: 0
  field :duration, type: Integer, default: 0

  def total_duration
    duration
  end

  def total_blocked_duration
    0.0
  end

  def conventional_costs
    0.0
  end

  def model_costs
    conventional_costs
  end

  def total_distance
    distance
  end
end
