class ByBicycle < Movement
  def blocked_duration
    duration
  end

  def model_blocked_duration
    route.subject.assigned_model == 'sav' ? 0 : model_duration
  end

  def model_costs
    return 0 if route.subject.assigned_model == 'pav'
    cost = 0.3 * distance
    cost = 2 * cost if route.cargo
    cost
  end

  def model_duration
    duration if route.subject.assigned_model == 'pav'
    distance.to_f / RESIDENTIAL_SAV_SPEED.to_f * 60.to_f
  end

  def ecological_costs
    distance * 7.64
  end

  def model_ecological_costs
    distance * 21.86
  end

  def first_class_model_ecological_costs
    distance * 43.72
  end
end
