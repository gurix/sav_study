class ByBicycle < Movement
  def total_blocked_duration
    duration
  end

  def model_costs
    0 if route.subject.assigned_model == 'pav'
    cost = 0.3 * distance if route.subject.assigned_model == 'sav'
    cost = 2 * cost if route.cargo
    cost
  end
end
