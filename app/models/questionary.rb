class Questionary # rubocop:disable Metrics/ClassLength
  include Mongoid::Document
  include Mongoid::Timestamps

  embedded_in :subject

  attr_accessor :page # We assign each question to a page and just validate it for specific pages

  # Questionary versions for the case, it changes during inquiry
  field :version, type: Integer, default: 1
  validates :version, presence: true

  # Page 1

  field :apf_quantity_ecology, type: Integer, default: 0
  validates :apf_quantity_ecology, presence: true, if: proc { |questionary|
    questionary.page.to_i == 1 && questionary.subject.dfference_by(:ecological_costs, :model_ecological_costs, per: :week) > 0
  }

  field :apf_feelings_ecology, type: Integer, default: 0
  validates :apf_feelings_ecology, presence: true, if: proc { |questionary|
    questionary.page.to_i == 1 && questionary.subject.dfference_by(:ecological_costs, :model_ecological_costs, per: :week) > 0
  }

  # Page 2

  field :apf_quantity_duration, type: Integer, default: 0
  validates :apf_quantity_duration, presence: true, if: proc { |questionary|
    questionary.page.to_i == 2 && questionary.subject.dfference_by(:duration, :model_duration, per: :week) > 0
  }

  field :apf_feelings_duration, type: Integer, default: 0
  validates :apf_feelings_duration, presence: true, if: proc { |questionary|
    questionary.page.to_i == 2 && questionary.subject.dfference_by(:duration, :model_duration, per: :week) > 0
  }

  # Page 3
  field :apf_quantity_costs, type: Integer, default: 0
  validates :apf_quantity_costs, presence: true, if: proc { |questionary|
    questionary.page.to_i == 3 && questionary.subject.dfference_by(:costs, :model_costs, per: :week) > 0
  }

  field :apf_feelings_costs, type: Integer, default: 0
  validates :apf_feelings_costs, presence: true, if: proc { |questionary|
    questionary.page.to_i == 3 && questionary.subject.dfference_by(:costs, :model_costs, per: :week) > 0
  }

  # Page 4

  (1..5).each do |i|
    field "implicite_general_acceptance_#{i}", type: Integer
    validates "implicite_general_acceptance_#{i}", presence: true, allow_blank: false, if: proc { |questionary| questionary.page.to_i == 4 }
  end

  # Page 5

  field :dimension_ranking_time, type: Integer, default: 1
  validates :dimension_ranking_time, presence: true, if: proc { |questionary| questionary.page.to_i == 5 }

  field :dimension_ranking_environment, type: Integer, default: 2
  validates :dimension_ranking_environment, presence: true, if: proc { |questionary| questionary.page.to_i == 5 }

  field :dimension_ranking_costs, type: Integer, default: 3
  validates :dimension_ranking_costs, presence: true, if: proc { |questionary| questionary.page.to_i == 5 }

  field :dimension_ranking_social, type: Integer, default: 4
  validates :dimension_ranking_social, presence: true, if: proc { |questionary| questionary.page.to_i == 5 }

  (1..3).each do |i|
    field "impicit_time_#{i}", type: Integer
    validates "impicit_time_#{i}", presence: true, allow_blank: false, if: proc { |questionary| questionary.page.to_i == 5 }
  end

  field :impicit_environment_1, type: Integer
  validates :impicit_environment_1, presence: true, allow_blank: false, if: proc { |questionary| questionary.page.to_i == 5 }

  field :impicit_environment_2, type: Integer
  validates :impicit_environment_2, presence: true, allow_blank: false, if: proc { |questionary|
    questionary.page.to_i == 5 && questionary.subject.assigned_model == 'sav'
  }

  field :impicit_environment_3, type: Integer
  validates :impicit_environment_3, presence: true, allow_blank: false, if: proc { |questionary| questionary.page.to_i == 5 }

  (1..3).each do |i|
    field "impicit_costs_#{i}", type: Integer
    validates "impicit_costs_#{i}", presence: true, allow_blank: false, if: proc { |questionary| questionary.page.to_i == 5 }
  end

  field :impicit_social_1, type: Integer
  validates :impicit_social_1, presence: true, allow_blank: false, if: proc { |questionary|
    questionary.page.to_i == 5 && questionary.subject.assigned_model == 'sav'
  }

  (2..3).each do |i|
    field "impicit_social_#{i}", type: Integer
    validates "impicit_social_#{i}", presence: true, allow_blank: false, if: proc { |questionary| questionary.page.to_i == 5 }
  end

  # Page 6

  field :acceptance_generally, type: Integer
  validates :acceptance_generally, presence: true, if: proc { |questionary| questionary.page.to_i == 6 }

  field :acceptance_environmental, type: Integer
  validates :acceptance_environmental, presence: true, if: proc { |questionary| questionary.page.to_i == 6 }

  field :acceptance_costs, type: Integer
  validates :acceptance_costs, presence: true, if: proc { |questionary| questionary.page.to_i == 6 }

  field :acceptance_time, type: Integer
  validates :acceptance_time, presence: true, if: proc { |questionary| questionary.page.to_i == 6 }

  field :acceptance_social, type: Integer
  validates :acceptance_social, presence: true, if: proc { |questionary| questionary.page.to_i == 6 }

  # Page 7

  (1..2).each do |i|
    field "context_needs_#{i}", type: Integer
    validates "context_needs_#{i}", presence: true, allow_blank: false, if: proc { |questionary| questionary.page.to_i == 7 }
  end

  (3..4).each do |i|
    field "context_needs_#{i}", type: Integer
    validates "context_needs_#{i}", presence: true, allow_blank: false, if: proc { |questionary|
      questionary.page.to_i == 7 && questionary.subject.assigned_model == 'sav'
    }
  end

  (5..8).each do |i|
    field "context_needs_#{i}", type: Integer
    validates "context_needs_#{i}", presence: true, allow_blank: false, if: proc { |questionary| questionary.page.to_i == 7 }
  end

  (9..10).each do |i|
    field "context_needs_#{i}", type: Integer
    validates "context_needs_#{i}", presence: true, allow_blank: false, if: proc { |questionary|
      questionary.page.to_i == 7 && questionary.subject.assigned_model == 'sav'
    }
  end

  (11..13).each do |i|
    field "context_needs_#{i}", type: Integer
    validates "context_needs_#{i}", presence: true, allow_blank: false, if: proc { |questionary| questionary.page.to_i == 7 }
  end

  field :context_concerns_1, type: Integer
  validates :context_concerns_1, presence: true, allow_blank: false, if: proc { |questionary| questionary.page.to_i == 7 }

  (2..4).each do |i|
    field "context_concerns_#{i}", type: Integer
    validates "context_concerns_#{i}", presence: true, allow_blank: false, if: proc { |questionary|
      questionary.page.to_i == 7 && questionary.subject.assigned_model == 'sav'
    }
  end

  (5..6).each do |i|
    field "context_concerns_#{i}", type: Integer
    validates "context_concerns_#{i}", presence: true, allow_blank: false, if: proc { |questionary| questionary.page.to_i == 7 }
  end

  (1..3).each do |i|
    field "context_anticipation_#{i}", type: Integer
    validates "context_anticipation_#{i}", presence: true, allow_blank: false, if: proc { |questionary| questionary.page.to_i == 7 }
  end

  # Page 8

  field :adoption, type: String
  validates :adoption, presence: true, allow_blank: false, if: proc { |questionary| questionary.page.to_i == 8 }

  # Page 9

  (1..2).each do |i|
    field "norm_consequences_#{i}", type: Integer
    validates "norm_consequences_#{i}", presence: true, allow_blank: false, if: proc { |questionary| questionary.page.to_i == 9 }
  end

  (1..2).each do |i|
    field "norm_responsibility_#{i}", type: Integer
    validates "norm_responsibility_#{i}", presence: true, allow_blank: false, if: proc { |questionary| questionary.page.to_i == 9 }
  end

  (1..2).each do |i|
    field "norm_personality_#{i}", type: Integer
    validates "norm_personality_#{i}", presence: true, allow_blank: false, if: proc { |questionary| questionary.page.to_i == 9 }
  end

  # Set default value for page
  def page
    @page || 1
  end
end
