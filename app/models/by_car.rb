class ByCar < Movement
  field :stopp_and_go, type: Integer, default: 0

  def car
    route.subject.car
  end

  def vehicle_category
    car.category
  end

  def type_of_power
    car.type_of_power
  end

  def blocked_duration
    duration
  end

  def model_blocked_duration
    route.subject.assigned_model == 'sav' ? 0 : model_duration
  end

  def costs # rubocop:disable Metrics/MethodLength
    costs_per_km = case vehicle_category
                   when 'fullsize' then 1.2
                   when 'compact' then 0.75
                   when 'micro' then 0.5
                   end
    savings_by_type_of_power = case type_of_power
                               when 'hybrid' then 10
                               when 'electro' then 50
                               else 0
                               end
    costs_per_km -= savings_by_type_of_power.percent_of(costs_per_km)
    costs_per_km * distance
  end

  def model_costs
    cost = 0.51 * distance if route.subject.assigned_model == 'pav'
    cost = 0.3 * distance if route.subject.assigned_model == 'sav'
    cost = 2 * cost if route.cargo
    cost
  end
end
