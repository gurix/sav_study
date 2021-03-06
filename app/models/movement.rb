class Movement
  RESIDENTIAL_SAV_SPEED = 50 # Speed of the SAV for residential sides a s replacements of foot or bicycle

  include Mongoid::Document
  embedded_in :route, polymorphic: true

  field :distance, type: Integer, default: 0
  field :duration, type: Integer, default: 0

  def blocked_duration
    0.0
  end

  def model_blocked_duration
    0.0
  end

  def costs
    0.0
  end

  def model_costs
    costs
  end

  def first_class_model_costs
    route.cargo ? model_costs : model_costs + (model_costs * 0.8)
  end

  def ecological_costs
    0.0
  end

  def model_ecological_costs
    ecological_costs
  end

  def first_class_model_ecological_costs
    model_ecological_costs
  end

  def model_duration
    duration
  end

  def model_distance
    distance
  end
end
