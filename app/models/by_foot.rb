class ByFoot < Movement
  def blocked_duration
    duration
 end

  def model_blocked_duration
    route.subject.assigned_model == 'sav' ? 0 : model_duration
  end

  def model_costs
    0 if route.subject.assigned_model == 'pav'
    cost = 0.3 * distance if route.subject.assigned_model == 'sav'
    cost = 2 * cost if route.cargo
    cost
  end

  def model_duration
    duration if route.subject.assigned_model == 'pav'
    distance.to_f / RESIDENTIAL_SAV_SPEED.to_f * 60.to_f
  end
end
