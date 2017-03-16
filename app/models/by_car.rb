class ByCar < Movement
  field :stopp_and_go, type: Integer, default: 0

  PRIVATE_RESERVATION_RATE = 0.8

  def car
    route.subject.car
  end

  def vehicle_category
    car.category
  end

  def type_of_power
    car.type_of_power
  end

  def model_duration
    duration - stopp_and_go
  end

  def blocked_duration
    duration
  end

  def model_blocked_duration
    0
  end

  def costs # rubocop:disable Metrics/MethodLength
    costs_per_km = case vehicle_category
                   when 'fullsize' then 1.2
                   when 'compact' then 0.75
                   when 'micro' then 0.5
                   end
    savings_by_type_of_power = case type_of_power
                               when 'hybrid' then 0.1
                               when 'electro' then 0.5
                               else 0
                               end
    costs_per_km -= costs_per_km * savings_by_type_of_power
    costs_per_km * distance
  end

  def model_costs
    cost = 0.51 * distance if route.subject.assigned_model == 'pav'
    cost = 0.3 * distance if route.subject.assigned_model == 'sav'
    cost += (cost * 0.8) if route.cargo
    cost
  end
end
