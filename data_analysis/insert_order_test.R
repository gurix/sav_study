library('corrplot')
library('corrgram')
library('lm.beta')
library('MASS')
source('prepare_data.R')

# Fileter people having no routing costs, i.e pedestrians
dataset <- subset(valid_sessions, route_costs > 0)

block1 <- lm(explicit_acceptance ~  log(route_costs) + (log(route_costs_difference + (min(dataset$route_costs_difference)*-1)+1) +  questionnaire_apf_feelings_costs), data=dataset)
block2 <- update(block1, . ~ . + log(route_duration) + log(route_duration_difference + (min(dataset$route_duration_difference)*-1)+1) + questionnaire_apf_feelings_duration)
block3 <- update(block2, . ~ . + log(route_ecological_costs) + log(route_ecological_costs_difference + (min(dataset$route_ecological_costs_difference)*-1)+1) + questionnaire_apf_feelings_ecology)
block4 <- update(block3, . ~ . + norm_consequences + norm_responsibility + norm_personality)
block5 <- update(block4, . ~ . + general_context_positive_antizipation + general_context_autonomy + general_context_aversion + general_context_driving_enjoyment)
block6 <- update(block5, . ~ . + assigned_model)
summary(block6)


# Fileter people having no routing costs, i.e pedestrians
dataset <- subset(valid_sessions, route_costs > 0)
block1x <- lm(explicit_acceptance ~ general_context_positive_antizipation + general_context_autonomy + general_context_aversion + general_context_driving_enjoyment, data=dataset)
block2x <- update(block1x, . ~ . + log(route_costs) + (log(route_costs_difference + (min(dataset$route_costs_difference)*-1)+1) +  questionnaire_apf_feelings_costs))
block3x <- update(block2x, . ~ . + log(route_duration) + log(route_duration_difference + (min(dataset$route_duration_difference)*-1)+1) + questionnaire_apf_feelings_duration)
block4x <- update(block3x, . ~ . + log(route_ecological_costs) + log(route_ecological_costs_difference + (min(dataset$route_ecological_costs_difference)*-1)+1) + questionnaire_apf_feelings_ecology)
block5x <- update(block4x, . ~ . + norm_consequences + norm_responsibility + norm_personality)
block6x <- update(block5x, . ~ . + assigned_model)
summary(block6x)

anova(block6, block6x)
options(scipen=999)
sort(lm.beta(block6)$standardized.coefficients) - sort(lm.beta(block6x)$standardized.coefficients)
