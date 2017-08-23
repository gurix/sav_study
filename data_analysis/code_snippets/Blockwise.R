library('lm.beta')
source('prepare_data.R')

dataset <- subset(valid_sessions, route_costs > 0)

block1 <- lm(explicit_acceptance ~  log(route_costs) + (log(route_costs_difference + (min(dataset$route_costs_difference)*-1)+1) +  questionnaire_apf_feelings_costs), data=dataset);summary.lm(block1)
lm.beta(block1)
bestglm::vifx(block1$model)

block2 <- update(block1, . ~ . + log(route_duration) + log(route_duration_difference + (min(dataset$route_duration_difference)*-1)+1) + questionnaire_apf_feelings_duration);summary.lm(block2)
lm.beta(block2)
bestglm::vifx(block2$model)

block3 <- update(block2, . ~ . + log(route_ecological_costs) + log(route_ecological_costs_difference + (min(dataset$route_ecological_costs_difference)*-1)+1) + questionnaire_apf_feelings_ecology);summary.lm(block3)
lm.beta(block3)
bestglm::vifx(block3$model)

block4 <- update(block3, . ~ . + norm_consequences + norm_responsibility + norm_personality);summary.lm(block4)
lm.beta(block4)
bestglm::vifx(block4$model)

anova(block1, block2, block3, block4)

# Das noch für PAV und SAV mit Kontextfaktoren am Anfang.
