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

  def total_distance
    routes.sum(&:total_distance)
  end

  def total_duration_per_week
    routes.sum(&:total_duration_per_week)
  end

  def total_distance_per_week
    routes.sum(&:total_distance_per_week)
  end

  private

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
