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

  validates :cargo, presence: true
  validates :purpose, presence: true

  def value_per_week(value)
    value * interval * 2
  end

  def total(trait, options = {})
    value = movements.inject(0) { |acc, elem| acc + (elem.send(trait) || 0) }
    options[:per] == :week ? value_per_week(value) : value
  end

  def total_by_type(trait, options = {})
    movements.map do |m|
      value = m.send(trait)
      value = value_per_week(value) if options[:per] == :week
      { m.class.to_s.underscore => value }
    end
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
