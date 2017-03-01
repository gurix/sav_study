class ByCar < Movement
  field :stopp_and_go, type: Integer, default: 0

  def total_duration
    duration
  end
end
