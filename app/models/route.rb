class Route
  include Mongoid::Document
  include Mongoid::Timestamps

  embedded_in :subject
  embeds_one :by_foot
  embeds_one :by_train
  
  accepts_nested_attributes_for :by_foot
  accepts_nested_attributes_for :by_train

  field :purpose, type: String
  field :interval, type: Integer, default: 1
  field :start_point, type: String
  field :end_point, type: String
  
  validates :purpose, presence: true
  
  def duration
    sum = 0
    sum += by_foot.duration if by_foot
    sum += by_train.duration if by_train
  end
  
  def distance
    sum = 0
    sum += by_foot.distance if by_foot
    sum += by_train.distance if by_train
  end
end
