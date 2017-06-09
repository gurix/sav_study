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

  field :acceptance_generally, type: Integer
  validates :acceptance_generally, presence: true, if: proc { |questionary| questionary.page.to_i == 4 }

  field :acceptance_environmental, type: Integer
  validates :acceptance_environmental, presence: true, if: proc { |questionary| questionary.page.to_i == 4 }

  field :acceptance_costs, type: Integer
  validates :acceptance_costs, presence: true, if: proc { |questionary| questionary.page.to_i == 4 }
  
  field :acceptance_time, type: Integer
  validates :acceptance_time, presence: true, if: proc { |questionary| questionary.page.to_i == 4 }

  field :acceptance_social, type: Integer
  validates :acceptance_social, presence: true, if: proc { |questionary| questionary.page.to_i == 4 }

  (1..5).each do |i|
    field "general_acceptance_#{i}", type: Integer
    validates "general_acceptance_#{i}", presence: true, allow_blank: false, if: proc { |questionary| questionary.page.to_i == 4 }
  end

  (1..2).each do |i|
    field "norm_consequences_#{i}", type: Integer
    validates "norm_consequences_#{i}", presence: true, allow_blank: false, if: proc { |questionary| questionary.page.to_i == 5 }
  end

  (1..2).each do |i|
    field "norm_responsibility_#{i}", type: Integer
    validates "norm_responsibility_#{i}", presence: true, allow_blank: false, if: proc { |questionary| questionary.page.to_i == 5 }
  end

  (1..2).each do |i|
    field "norm_personality_#{i}", type: Integer
    validates "norm_personality_#{i}", presence: true, allow_blank: false, if: proc { |questionary| questionary.page.to_i == 5 }
  end

  field :dimension_ranking_time, type: Integer, default: 0
  validates :dimension_ranking_time, presence: true, if: proc { |questionary| questionary.page.to_i == 6 } 

  field :dimension_ranking_environment, type: Integer, default: 1
  validates :dimension_ranking_environment, presence: true, if: proc { |questionary| questionary.page.to_i == 6 }

  field :dimension_ranking_costs, type: Integer, default: 2
  validates :dimension_ranking_costs, presence: true, if: proc { |questionary| questionary.page.to_i == 6 }

  field :dimension_ranking_social, type: Integer, default: 3
  validates :dimension_ranking_social, presence: true, if: proc { |questionary| questionary.page.to_i == 6 }

  field :adoption, type: String
  validates :adoption, presence: true, allow_blank: false, if: proc { |questionary| questionary.page.to_i == 6 }

  # Set default value for page
  def page
    @page || 1
  end
end
