require 'csv'
class CSVExport
  def for_subject(subject)
    CSV.generate_line(extract_values(subject_fields, subject) +
                      extract_values(car_fields, subject.car) +
                      extract_values(questionnaire_fields, subject.questionary) +
                      route_values(subject))
  end

  def header
    CSV.generate_line(subject_fields +
    car_fields.map { |f| "car_#{f}" } +
    questionnaire_fields.map { |f| "questionnaire_#{f}" } +
    route_fields.map { |f| "route_#{f}" })
  end

  private

  def subject_fields
    @subject_fields ||= Subject.fields.keys
  end

  def car_fields
    @car_fields ||= Car.fields.keys - %w(_id created_at updated_at)
  end

  def questionnaire_fields
    @questionnaire_fields ||= Questionary.fields.keys - %w(_id created_at updated_at)
  end

  def route_fields
    %w(count blocked_duration model_blocked_duration costs model_costs ecological_costs model_ecological_costs duration model_duration distance model_distance)
  end

  def route_values(subject)
    [subject.routes.count, subject.total(:blocked_duration, per: :week),
     subject.total(:model_blocked_duration, per: :week),
     subject.total(:costs, per: :week),
     subject.total(:model_costs, per: :week),
     subject.total(:ecological_costs, per: :week),
     subject.total(:model_ecological_costs, per: :week),
     subject.total(:duration, per: :week),
     subject.total(:model_duration, per: :week),
     subject.total(:distance, per: :week),
     subject.total(:model_distance, per: :week)]
  end

  def extract_values(fields, document)
    fields.map do |field|
      document ? document.attributes[field] : nil
    end
  end
end
