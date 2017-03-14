class ByLocalLine < Movement
  def conventional_costs
    0.865 * distance
  end

  def model_costs
    return 0.865 * distance if route.subject.assigned_model == 'pav'
    cost = 0.3 * distance if route.subject.assigned_model == 'sav'
    cost = 2 * cost if route.cargo
    cost
  end
end
