# Read data
raw_sessions <- read.csv('./data/sav_study_20170801.csv')

colnames(raw_sessions) <- gsub('impicit', 'implicit', colnames(raw_sessions), fixed=TRUE)

# Filter data generated before launching the experiment
cutoff_day <- "2017-07-15"
raw_sessions <- subset(raw_sessions, as.Date(created_at) > as.Date(cutoff_day))

# To ensure participants finish the questionnaire, filter all data having at least a birth year
valid_sessions <- subset(raw_sessions, !is.na(raw_sessions$birthyear))

# Canclulate ho long the experiment last for each participant
valid_sessions$fill_in_speed <- difftime(valid_sessions$updated_at, valid_sessions$created_at)

# Caclulate ho long the experiment last for each participant and filter out participants having less then 5 minutes to fill in the questionarie.
valid_sessions$fill_in_speed <- difftime(valid_sessions$updated_at, valid_sessions$created_at)
valid_sessions <- subset(valid_sessions, fill_in_speed > 5)

# Exclude participants don not fill out their mobility profile properly
valid_sessions <- subset(valid_sessions, route_distance > 0)
valid_sessions <- subset(valid_sessions, route_duration > 0)

# Fix empty car_category
levels(valid_sessions$car_category)[levels(valid_sessions$car_category)==""] <- "none"

# As most of the participants originate from a paid panel, we should exclude participants having any patterns in their answers i.e always the the same value.
items_to_test <- names(valid_sessions)[grepl( "questionnaire_" , names(valid_sessions))]
items_to_test <- items_to_test[items_to_test != 'questionnaire_adoption']
items_to_test <- items_to_test[items_to_test != 'questionnaire_version']
valid_sessions$max_unique_choices_test <-  apply(valid_sessions[,items_to_test],1,function(x) { max(table(x))})
valid_sessions <- subset(valid_sessions, max_unique_choices_test < 40)

# Mark people did sort the dimension ranking
valid_sessions$ranking_sorted <- valid_sessions$questionnaire_dimension_ranking_social != 4

# Aggregate age
valid_sessions$age <- 2017 - valid_sessions$birthyear

# Add spatial planing indicators
library(xlsx)
zones <- read.xlsx(file = "data/be-b-00.04-rgs-01.xls", sheetName = "01.01.2016", startRow = 17,colIndex = c(1,2,16,17,22))
colnames(zones) <- c('bfsnr','city_name','community_size_class', 'urban_vs_rural_areas_2000','degurba')
zip_to_bfsnr <- read.xlsx(file = "data/do-t-09.02-gwr-37.xls", sheetName = "PLZ4", startRow = 1 ,colIndex = c(1,2,4))
colnames(zip_to_bfsnr) <- c('plz', 'percent_of_community', 'bfsnr')
zip_to_bfsnr <- zip_to_bfsnr[order(100-zip_to_bfsnr$percent_of_community),] 
zip_to_bfsnr_uniq <- zip_to_bfsnr[!duplicated(zip_to_bfsnr$plz),]
zones_by_zip <- merge(zip_to_bfsnr_uniq, zones)
valid_sessions <- merge(valid_sessions,zones_by_zip, all.x=T)

# Drop empty levels in factors
valid_sessions <- droplevels(valid_sessions)

# Reverse data if recoded (RUN only once!)
valid_sessions$questionnaire_implicite_general_acceptance_4 <- 6 - valid_sessions$questionnaire_implicite_general_acceptance_4
valid_sessions$questionnaire_implicite_general_acceptance_5 <- 6 - valid_sessions$questionnaire_implicite_general_acceptance_5
valid_sessions$questionnaire_context_anticipation_1 <- 6 - valid_sessions$questionnaire_context_anticipation_1
valid_sessions$questionnaire_context_anticipation_2 <- 6 - valid_sessions$questionnaire_context_anticipation_2
valid_sessions$questionnaire_context_anticipation_3 <- 6 - valid_sessions$questionnaire_context_anticipation_3

# Aggregate dimensions
valid_sessions$explicit_acceptance = rowMeans(valid_sessions[,names(valid_sessions)[grepl( "questionnaire_acceptance_" , names(valid_sessions))]], na.rm=T)

valid_sessions$implicite_general_acceptance = rowMeans(valid_sessions[,names(valid_sessions)[grepl( "questionnaire_implicite_general_acceptance_" , names(valid_sessions))]], na.rm=T)

valid_sessions$apf_quantity = rowMeans(valid_sessions[,names(valid_sessions)[grepl( "questionnaire_apf_quantity_" , names(valid_sessions))]], na.rm=T)
valid_sessions$apf_feelings = rowMeans(valid_sessions[,names(valid_sessions)[grepl( "questionnaire_apf_feelings_" , names(valid_sessions))]], na.rm=T)

valid_sessions$norm_consequences = rowMeans(valid_sessions[,names(valid_sessions)[grepl( "questionnaire_norm_consequences" , names(valid_sessions))]], na.rm=T)
valid_sessions$norm_responsibility = rowMeans(valid_sessions[,names(valid_sessions)[grepl( "questionnaire_norm_responsibility" , names(valid_sessions))]], na.rm=T)
valid_sessions$norm_personality = rowMeans(valid_sessions[,names(valid_sessions)[grepl( "questionnaire_norm_personality" , names(valid_sessions))]], na.rm=T)

valid_sessions$implicit_time = rowMeans(valid_sessions[,names(valid_sessions)[grepl( "questionnaire_implicit_time" , names(valid_sessions))]], na.rm=T)
valid_sessions$implicit_costs = rowMeans(valid_sessions[,names(valid_sessions)[grepl( "questionnaire_implicit_costs" , names(valid_sessions))]], na.rm=T)
valid_sessions$implicit_environment = rowMeans(valid_sessions[,names(valid_sessions)[grepl( "questionnaire_implicit_environment" , names(valid_sessions))]], na.rm=T)
valid_sessions$implicit_social = rowMeans(valid_sessions[,names(valid_sessions)[grepl( "questionnaire_implicit_social" , names(valid_sessions))]], na.rm=T)

valid_sessions$implicit_acceptance <- rowMeans(valid_sessions[,names(valid_sessions)[grepl( "questionnaire_implicit" , names(valid_sessions))]], na.rm=T)

valid_sessions$innovation <- valid_sessions$questionnaire_adoption

valid_sessions$route_costs_difference <- valid_sessions$route_cost - valid_sessions$route_model_costs
valid_sessions$route_ecological_costs_difference <- valid_sessions$route_ecological_costs - valid_sessions$route_model_ecological_costs
valid_sessions$route_duration_difference <- valid_sessions$route_duration - valid_sessions$route_model_duration

# Log transformation for regression models
valid_sessions$log_route_costs <- log(valid_sessions$route_costs)
valid_sessions$log_route_duration <- log(valid_sessions$route_duration)
valid_sessions$log_route_ecological_costs <- log(valid_sessions$route_ecological_costs)

valid_sessions$log_route_costs_difference <-log(valid_sessions$route_costs_difference + (min(valid_sessions$route_costs_difference) * -1) + 1)
valid_sessions$log_route_duration_difference <- log(valid_sessions$route_duration_difference + (min(valid_sessions$route_duration_difference) * -1) + 1)
valid_sessions$log_route_ecological_costs_difference <- log(valid_sessions$route_ecological_costs_difference + (min(valid_sessions$route_ecological_costs_difference) * -1) + 1)


# Cut off calculated based on swiss trafic behavior https://www.bfs.admin.ch/bfs/de/home/statistiken/mobilitaet-verkehr/personenverkehr/verkehrsverhalten.assetdetail.1840604.html
valid_sessions$route_duration_cutted_off <- (valid_sessions$route_duration/7) > 90.4

# Level of measurement for some variables
valid_sessions$education <- as.ordered(valid_sessions$education)
valid_sessions$income <- as.ordered(valid_sessions$income)
valid_sessions$community_size_class <- as.ordered(valid_sessions$community_size_class)
valid_sessions$urban_vs_rural_areas_2000 <- as.ordered(valid_sessions$urban_vs_rural_areas_2000)

### F1 (positive Antizipation)
valid_sessions$general_context_positive_antizipation <- rowMeans(valid_sessions[,c('questionnaire_context_anticipation_1', 
                                                                                   'questionnaire_context_anticipation_2', 
                                                                                   'questionnaire_context_anticipation_3')],na.rm=T)
### F2 (Unabhängigkeit/Autonomie)
valid_sessions$general_context_autonomy <- rowMeans(valid_sessions[,c('questionnaire_context_needs_2', 
                                                                      'questionnaire_context_needs_5',
                                                                      'questionnaire_context_needs_7', 
                                                                      'questionnaire_context_needs_8', 
                                                                      'questionnaire_context_needs_11',
                                                                      'questionnaire_context_concerns_1')],na.rm=T)
### F3 (Systemzweifel und Abneigung)
valid_sessions$general_context_aversion <- rowMeans(valid_sessions[,c('questionnaire_context_concerns_5',
                                                                      'questionnaire_context_concerns_6')],na.rm=T)

### F4 (Freude am aktiven Fahren)
valid_sessions$general_context_driving_enjoyment <- rowMeans(valid_sessions[,c('questionnaire_context_needs_12', 
                                                                               'questionnaire_context_needs_13')],na.rm=T)


# Two groups for PAV and SAV
valid_sessions.pav <- subset(valid_sessions, assigned_model =='pav')

## Aggregate context factors
### F1 (positive Antizipation)
valid_sessions.pav$context_positive_antizipation <- rowMeans(valid_sessions.pav[,c('questionnaire_context_anticipation_1', 
                                                                               'questionnaire_context_anticipation_2', 
                                                                               'questionnaire_context_anticipation_3')],na.rm=T)
### F2 (Unabhängigkeit/Autonomie)
valid_sessions.pav$context_autonomy <- rowMeans(valid_sessions.pav[,c('questionnaire_context_needs_1', 
                                                                  'questionnaire_context_needs_2', 
                                                                  'questionnaire_context_needs_5',
                                                                  'questionnaire_context_needs_7', 
                                                                  'questionnaire_context_needs_8', 
                                                                  'questionnaire_context_needs_11')],na.rm=T)
### F3 (Systemzweifel und Abneigung)
valid_sessions.pav$context_aversion <- rowMeans(valid_sessions.pav[,c('questionnaire_context_concerns_1', 
                                                                  'questionnaire_context_concerns_5',
                                                                  'questionnaire_context_concerns_6')],na.rm=T)

### F4 (Freude am aktiven Fahren)
valid_sessions.pav$context_driving_enjoyment <- rowMeans(valid_sessions.pav[,c('questionnaire_context_needs_12', 
                                                                   'questionnaire_context_needs_13')],na.rm=T)

valid_sessions.sav <- subset(valid_sessions, assigned_model =='sav')
## Aggregate context factors
### F1 (Zweifel am Konzept und an der Kompetenz des Autos)
valid_sessions.sav$context_disbelief_in_av <- rowMeans(valid_sessions.sav[,c('questionnaire_context_needs_3',
                                                                         'questionnaire_context_concerns_5',
                                                                         'questionnaire_context_concerns_6')],na.rm=T)
  
### F2 (Abneigung Fremde)
valid_sessions.sav$context_dislike_strangers <- rowMeans(valid_sessions.sav[,c('questionnaire_context_needs_8'
                                                                           ,'questionnaire_context_needs_9',
                                                                           'questionnaire_context_concerns_1',
                                                                           'questionnaire_context_concerns_2')],na.rm=T)

### F3 (positive Antizipation)
valid_sessions.sav$context_positive_antizipation <- rowMeans(valid_sessions.sav[,c('questionnaire_context_anticipation_1',
                                                                               'questionnaire_context_anticipation_2',
                                                                               'questionnaire_context_anticipation_3')],na.rm=T)

### F4 (Entfaltung und persönliche Freiheit)
valid_sessions.sav$context_liberty <- rowMeans(valid_sessions.sav[,c('questionnaire_context_needs_11',
                                                                 'questionnaire_context_needs_12',
                                                                 'questionnaire_context_needs_13')],na.rm=T)

### F5 (Zweifel Verfügbarkeit)
valid_sessions.sav$context_availability <- rowMeans(valid_sessions.sav[,c('questionnaire_context_concerns_3',
                                                                      'questionnaire_context_concerns_4')],na.rm=T)

### F6 (Unabhängigkeit & Transport)
valid_sessions.sav$context_transport_and_individualisation <- rowMeans(valid_sessions.sav[,c('questionnaire_context_needs_2',
                                                                                         'questionnaire_context_needs_4',
                                                                                         'questionnaire_context_needs_6')],na.rm=T)

### F7 (Transport & Individualisierung)
valid_sessions.sav$context_independence <- rowMeans(valid_sessions.sav[,c('questionnaire_context_needs_5',
                                                                      'questionnaire_context_needs_10')],na.rm=T)

