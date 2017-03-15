class Subject
  include Mongoid::Document
  include Mongoid::Timestamps

  embeds_many :routes
  embeds_one :car
  embeds_one :questionary

  field :gender, type: String
  field :birthyear, type: Integer
  field :education, type: Integer
  field :income, type: Integer
  field :plz, type: Integer
  field :city, type: String
  field :email, type: String
  field :token, type: String

  validates :token, uniqueness: true
  validates :gender, presence: true, if: :routes_added?
  validates :birthyear, presence: true, if: :routes_added?
  validates :education, presence: true, if: :routes_added?
  validates :income, presence: true, if: :routes_added?
  # validates :plz, presence: true, if: :routes_added?
  # validates :city, presence: true, if: :routes_added?

  validate :correct_age, if: :routes_added?

  index created_at: 1
  index updated_at: 1

  before_create :reset_token

  def assigned_model
    'sav'
  end

  def correct_age
    return unless birthyear
    this_year = DateTime.now.year
    errors.add(:birthyear, I18n.t('subjects.errors.to_old')) if birthyear < this_year - 100
    errors.add(:birthyear, I18n.t('subjects.errors.to_young')) if birthyear > this_year - 12
  end

  def reset_token
    self.token = generate_token(4) until unique_token?
  end

  def total_duration
    routes.sum(&:total_duration)
  end

  def total_free_duration
    total_duration - total_blocked_duration
  end

  def total_distance
    routes.sum(&:total_distance)
  end

  def total_blocked_duration_per_week
    routes.sum(&:total_blocked_duration_per_week)
  end

  def total_model_blocked_duration_per_week
    routes.sum(&:total_model_blocked_duration_per_week)
  end

  def total_free_duration_per_week
    total_duration_per_week - total_blocked_duration_per_week
  end

  def total_model_free_duration_per_week
    total_model_duration_per_week - total_model_blocked_duration_per_week
  end

  def total_duration_per_week
    routes.sum(&:total_duration_per_week)
  end

  def total_model_duration_per_week
    routes.sum(&:total_model_duration_per_week)
  end

  def total_distance_per_week
    routes.sum(&:total_distance_per_week)
  end

  def total_conventional_costs_per_week
    routes.sum(&:total_conventional_costs_per_week)
  end

  def total_model_costs_per_week
    routes.sum(&:total_model_costs_per_week)
  end

  def conventional_costs_by_type
    aggregate(routes.map(&:conventional_costs_by_type))
  end

  def model_costs_by_type
    aggregate(routes.map(&:model_costs_by_type))
  end

  def conventional_durations_by_type
    aggregate(routes.map(&:conventional_durations_by_type))
  end

  def model_durations_by_type
    aggregate(routes.map(&:model_durations_by_type))
  end

  def conventional_distances_by_type
    aggregate(routes.map(&:conventional_distances_by_type))
  end

  private

  def aggregate(values)
    values.flatten.inject do |a, b|
      a.merge(b) { |_, x, y| x + y }
    end
  end

  def routes_added?
    routes.any?
  end

  def generate_token(size)
    SecureRandom.base64(size).downcase.delete('/+=')[0, size]
  end

  def unique_token?
    field = :token
    self.class.where(field => send(field)).blank? && send(field).present?
  end
end
