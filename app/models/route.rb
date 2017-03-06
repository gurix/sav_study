class Route
  include Mongoid::Document
  include Mongoid::Timestamps

  after_initialize :initialize_movements

  embedded_in :subject

  embeds_one :by_foot
  embeds_one :by_car
  embeds_one :by_train
  embeds_one :by_bicycle
  embeds_one :by_local_line

  accepts_nested_attributes_for :by_foot
  accepts_nested_attributes_for :by_car
  accepts_nested_attributes_for :by_train
  accepts_nested_attributes_for :by_bicycle
  accepts_nested_attributes_for :by_local_line

  field :purpose,     type: String
  field :interval,    type: Integer, default: 1
  field :start_point, type: String
  field :end_point,   type: String
  field :cargo,       type: Boolean

  validates :purpose, presence: true

  def total_duration
    movements.inject(0) { |acc, elem| acc + elem.total_duration }
  end

  def total_blocked_duration
    movements.inject(0) { |acc, elem| acc + elem.total_blocked_duration }
  end

  def total_conventional_costs
    movements.inject(0) { |acc, elem| acc + elem.conventional_costs.round(2) }
  end

  def total_duration_per_week
    2 * total_duration * interval
  end

  def total_blocked_duration_per_week
    2 * total_blocked_duration * interval
  end

  def total_distance
    movements.inject(0) { |acc, elem| acc + elem.total_distance }
  end

  def conventional_costs_by_type
    movements.map { |m| {m.class.to_s.underscore =>  2 * interval * m.conventional_costs.round(2)}}
  end

  def conventional_durations_by_type
    movements.map { |m| {m.class.to_s.underscore =>  2 * interval * m.duration}}
  end

  def conventional_distances_by_type
    movements.map { |m| {m.class.to_s.underscore =>  2 * interval * m.distance}}
  end

  def total_distance_per_week
    2 * total_distance * interval
  end

  def total_conventional_costs_per_week
    2 * total_conventional_costs * interval
  end

  def movements
    [by_foot, by_car, by_train, by_bicycle, by_local_line].compact
  end

  def initialize_movements
    self.by_foot       ||= ByFoot.new
    self.by_car        ||= ByCar.new
    self.by_train      ||= ByTrain.new
    self.by_bicycle    ||= ByBicycle.new
    self.by_local_line ||= ByLocalLine.new
  end
end
