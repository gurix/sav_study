class Movement
  include Mongoid::Document
  embedded_in :route, polymorphic: true

  field :distance, type: Integer, default: 0
  field :duration, type: Integer, default: 0

  def total_duration
    duration
  end

  def total_distance
    distance
  end
end
