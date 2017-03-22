class ByTrain < Movement
  def costs
    0.75 * distance
  end

  def first_class_model_costs
    model_costs
  end

  def ecological_costs
    distance * 7.86
  end
end
