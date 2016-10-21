class Subject
  include Mongoid::Document
  include Mongoid::Timestamps

  embeds_many :routes

  field :gender, type: String
  field :birthyear, type: Integer
  field :education, type: Integer
  field :income, type: Integer
  field :pt_connection_duration, type: Integer
  field :pt_connection_interval, type: Integer
  field :plz, type: Integer
  field :city, type: String
  field :email, type: String
  field :token, type: String

  validates :token, uniqueness: true

  index created_at: 1
  index updated_at: 1

  before_create :reset_token

  def reset_token
    self.token = generate_token(4) until unique_token?
  end

  private

  def generate_token(size)
    SecureRandom.base64(size).downcase.delete('/+=')[0, size]
  end

  def unique_token?
    field = :token
    self.class.where(field => send(field)).blank? && send(field).present?
  end
end
