class Questionary
  include Mongoid::Document
  include Mongoid::Timestamps

  embedded_in :subject

  attr_accessor :page # We assign each question to a page and just validate it for specific pages

  # Questionary versions for the case, it changes during inquiry
  field :version, type: Integer, default: 1
  validates :version, presence: true

  field :apf_quantity_ecology, type: Integer, default: 0
  validates :apf_quantity_ecology, presence: true, if: proc { |questionary|
    questionary.page.to_i == 1 && questionary.subject.dfference_by(:ecological_costs, :model_ecological_costs, per: :week) > 0
  }

  field :apf_quantity_duration, type: Integer, default: 0
  validates :apf_quantity_duration, presence: true, if: proc { |questionary|
    questionary.page.to_i == 2 && questionary.subject.dfference_by(:duration, :model_duration, per: :week) > 0
  }

  field :apf_quantity_costs, type: Integer, default: 0
  validates :apf_quantity_costs, presence: true, if: proc { |questionary|
    questionary.page.to_i == 3 && questionary.subject.dfference_by(:costs, :model_costs, per: :week) > 0
  }

  field :apf_feelings_ecology, type: Integer, default: 0
  validates :apf_feelings_ecology, presence: true, if: proc { |questionary|
    questionary.page.to_i == 1 && questionary.subject.dfference_by(:ecological_costs, :model_ecological_costs, per: :week) > 0
  }

  field :apf_feelings_duration, type: Integer, default: 0
  validates :apf_feelings_duration, presence: true, if: proc { |questionary|
    questionary.page.to_i == 2 && questionary.subject.dfference_by(:duration, :model_duration, per: :week) > 0
  }

  field :apf_feelings_costs, type: Integer, default: 0
  validates :apf_feelings_costs, presence: true, if: proc { |questionary|
    questionary.page.to_i == 3 && questionary.subject.dfference_by(:costs, :model_costs, per: :week) > 0
  }

  field :answer_3, type: Integer, default: 0
  validates :answer_3, presence: true, if: proc { |questionary| questionary.page.to_i == 4 }

  field :adoption, type: String
  validates :adoption, presence: true, allow_blank: false, if: proc { |questionary| questionary.page.to_i == 5 }

  # Set default value for page
  def page
    @page || 1
  end
end
