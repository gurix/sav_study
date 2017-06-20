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

  def ecological_costs
    costs_per_km = case vehicle_category
                   when 'fullsize' then 242.1
                   when 'compact' then 202.4
                   when 'micro' then 162.7
                   end

    costs_per_km = 81.6 if type_of_power == 'electro'
    costs_per_km = 158 if type_of_power == 'hybrid'
    (costs_per_km * distance)
  end

  def model_ecological_costs
    return distance * 27.32 if route.subject.assigned_model == 'pav'
    return distance * 21.86 if route.subject.assigned_model == 'sav'
  end

  def first_class_model_ecological_costs
    distance * 43.72
  end
end
