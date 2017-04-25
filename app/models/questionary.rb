class Questionary
  include Mongoid::Document
  include Mongoid::Timestamps

  embedded_in :subject

  attr_accessor :page # We assign each question to a page and just validate it for specific pages

  # Questionary versions for the case, it changes during inquiry
  field :version, type: Integer, default: 1
  validates :version, presence: true

  field :answer_1, type: Integer, default: 0
  validates :answer_1, presence: true, if: proc { |questionary| questionary.page.to_i == 1 }

  field :answer_2, type: Integer, default: 0
  validates :answer_2, presence: true, if: proc { |questionary| questionary.page.to_i == 1 }

  field :answer_3, type: Integer, default: 0
  validates :answer_3, presence: true, if: proc { |questionary| questionary.page.to_i == 2 }

  field :adoption, type: String
  validates :adoption, presence: true, allow_blank: false, if: proc { |questionary| questionary.page.to_i == 3 }
end
