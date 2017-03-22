class ByLocalLine < Movement
  def costs
    0.865 * distance
  end

  def model_costs
    return 0.865 * distance if route.subject.assigned_model == 'pav'
    cost = 0.3 * distance if route.subject.assigned_model == 'sav'
    cost = 2 * cost if route.cargo
    cost
  end

  def model_duration
    duration if route.subject.assigned_model == 'pav'
    distance.to_f / RESIDENTIAL_SAV_SPEED.to_f * 60.to_f
  end

  def ecological_costs
    distance * 24.78
  end

  def model_ecological_costs
    distance * 13.62
  end

  def first_class_model_ecological_costs
    distance * 21.79
  end
end
