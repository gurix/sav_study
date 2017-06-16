require 'rails_helper'

feature 'Survey' do
  scenario 'A user fills in the whole survey', js: true do
    allow_any_instance_of(Subject).to receive(:assigned_model).and_return("sav")
    
    visit root_path

    click_link 'Eine neue Befragung starten'

    choose 'car_car_owner_true'
    choose 'car_is_commuter_true'
    choose 'Kompaktklasse (6 - 10 Liter / 100 Kilometer)'
    choose 'Konventionelles Fahrzeug betrieben mit Benzin oder Diesel'

    click_button 'Weiter'

    click_link 'Meine erste Stecke definieren ...'

    choose '... um zu meinem Arbeitplatz oder meiner Ausbildungsstädte zu kommen.'
    choose 'route_cargo_false'

    find('#route_interval', visible: false).set 3

    fill_in 'Startpunkt', with: 'A'
    fill_in 'Endpunkt', with: 'B'

    find('#route_by_foot_attributes_distance', visible: false).set 1
    find('#route_by_foot_attributes_duration', visible: false).set 10
    find('#route_by_car_attributes_distance', visible: false).set 30
    find('#route_by_car_attributes_duration', visible: false).set 20
    find('#route_by_car_attributes_stopp_and_go', visible: false).set 4
    find('#route_by_train_attributes_distance', visible: false).set 2
    find('#route_by_train_attributes_duration', visible: false).set 5
    find('#route_by_bicycle_attributes_distance', visible: false).set 1
    find('#route_by_bicycle_attributes_duration', visible: false).set 5
    find('#route_by_local_line_attributes_distance', visible: false).set 2
    find('#route_by_local_line_attributes_duration', visible: false).set 5

    click_button 'Speichern'

    expect(page).to have_content 'Sie haben nun Ihre erste Strecke definiert.'

    click_link 'Weiter zur Auswertung'

    expect(page).to have_content 'Sie sind in der in einer Woche insgesamt etwa 5 Stunden unterwegs.'
    expect(page).to have_content 'Von der Zeit, in der Sie unterwegs sind, können Sie etwa eine Stunde für andere Tätigkeiten nutzen'
    expect(page).to have_content 'Sie legen pro Woche insgesamt eine Strecke von 216.0 Kilometer zurück.'
    expect(page).to have_content 'Die dabei entstehenden Mobilitätskosten belaufen sich auf 154.38 CHF.'
    expect(page).to have_content 'Sie belasten die Umwelt durch Ihre zurückgelegte Strecke mit insgesamt 32.82 Kg CO2 Emissionen.'    

    click_link 'Weiter zu den neuen Mobilitätsformen'

    check 'Autonome Fahrzeuge haben ein höheres Unfallrisiko'
    check 'Als Insasse müssen Sie jederzeit in das Geschehen eingreifen können und die Steuerung des Fahrzeugs übernehmen können.'

    click_button 'Antworten überprüfen'

    expect(page).to have_content 'Sie haben alle Fragen korrekt beantwortet.'

    click_link 'Weiter zu meinem zukünftigen Mobilitätsprofil'

    expect(page).to have_content 'In Zukunft sind Sie mit einem autonomen Auto etwa 3 Stunden unterwegs.'
    expect(page).to have_content 'Sie das Fahrzeug immer nur für sich alleine reservieren so, dass niemand zusätzlich zusteigen kann, belaufen sich die Kosten für diese Einzelfahrten auf 119.16 CHF.'
    expect(page).to have_content 'In Zukunft belaufen sich die Kosten für die Nutzung mit einem autonomen Auto auf 70.2 CHF.'
    expect(page).to have_content 'In Zukunft wird durch Ihre Nutzung eines autonomen Autos 2.3 Kg CO2 emittiert.'
    expect(page).to have_content 'Wenn Sie das Fahrzeug immer nur für sich alleine reservieren so, dass niemand zusätzlich zusteigen kann, belasten Sie damit die Umwelt mit 4.41 Kg CO2.'

    click_link 'Weiter zur Befragung'

    expect(page).to have_content 'Die wöchentlichen Einsparungen an 30.52 Kg CO2'

    click_button 'Weiter'

    expect(page).to have_content 'Die wöchentlichen Einsparungen an etwa 2 Stunden Zeit, die ich durch die Nutzung eines autonomen Autos erreichen kann, sind für mich'

    click_button 'Weiter'

    expect(page).to have_content 'Die wöchentlichen Einsparungen an 84.18 CHF (Geld)'

    click_button 'Weiter'

    choose 'questionary_implicite_general_acceptance_1_1'
    choose 'questionary_implicite_general_acceptance_2_1'
    choose 'questionary_implicite_general_acceptance_3_1'
    choose 'questionary_implicite_general_acceptance_4_1'
    choose 'questionary_implicite_general_acceptance_5_1'

    click_button 'Weiter'

    choose 'questionary_impicit_time_1_1'
    choose 'questionary_impicit_time_2_1'
    choose 'questionary_impicit_time_3_1'
    choose 'questionary_impicit_environment_1_1'
    choose 'questionary_impicit_environment_2_1'
    choose 'questionary_impicit_environment_3_1'
    choose 'questionary_impicit_costs_1_1'
    choose 'questionary_impicit_costs_2_1'
    choose 'questionary_impicit_costs_3_1'
    choose 'questionary_impicit_social_1_1'
    choose 'questionary_impicit_social_2_1'
    choose 'questionary_impicit_social_3_1'

    click_button 'Weiter'
    
    choose 'questionary_acceptance_generally_1'
    choose 'questionary_acceptance_environmental_1'
    choose 'questionary_acceptance_costs_1'
    choose 'questionary_acceptance_time_1'
    choose 'questionary_acceptance_social_1'
    
    click_button 'Weiter'
    
    (1..13).each do |i|
      choose "questionary_context_needs_#{i}_1"
    end

    (1..6).each do |i|
      choose "questionary_context_concerns_#{i}_1"
    end

    (1..3).each do |i|
      choose "questionary_context_anticipation_#{i}_1"
    end
  
    click_button 'Weiter'

    choose 'questionary_adoption_innovators'

    click_button 'Weiter'

    (1..2).each do |i|
       choose "questionary_norm_consequences_#{i}_1"
    end

    (1..2).each do |i|
       choose "questionary_norm_responsibility_#{i}_1"
    end

    (1..2).each do |i|
       choose "questionary_norm_personality_#{i}_1"
    end

    click_button 'Weiter'

    choose 'subject_gender_male'

    choose 'subject_income_1'

    fill_in 'Geburtsjahr', with: '1981'

    choose 'subject_education_2'

    fill_in 'Postleitzahl', with: '1234'

    click_button 'Befragung abschliessen'

    expect(page).to have_content 'Besten Dank für Ihre Teilnahme! Sie sind damit am Ende der Umfrage angekommen.'

    fill_in 'E-Mail-Adresse', with: 'info@markusgraf.ch'

    click_button 'Eintragen'

    expect(Newsletter.asc(:create_at).last.email).to eq 'info@markusgraf.ch'

    expect(page).to have_content 'Besten Dank. Ihre E-Mail-Addresse wurde eingetragen.'
  end
end