library(bestglm)

# Laoding data
source('prepare_data.R')


# Leap the data
# apf_quantity fliegt raus wegen autokorelation mit apf_feelings
items = c('implicite_general_acceptance',
          'apf_feelings',
          'innovation',
          'norm_consequences',
          'norm_responsibility',
          'norm_personality',
          'impicit_time',
          'impicit_costs',
          'impicit_environment',
          'impicit_social',
          'assigned_model',
          'age',
          'gender',
          'education',
          'income',
          'urban_vs_rural_areas_2000',
          'community_size_class',
          'car_category',
          'explicit_acceptance')

sessions_for_regression = valid_sessions[,items]

resbestglm<- bestglm(na.omit(sessions_for_regression));
resbestglm

plot(resbestglm, scale = "adjr2", main = "Adjusted R^2")


xitems = c('implicite_general_acceptance',
           'impicit_time',
           'impicit_costs',
           'impicit_environment',
           'impicit_social',
           'apf_feelings',
           'norm_consequences',
           'norm_responsibility',
           'norm_personality',
           'age',
           'explicit_acceptance')

View(cor(valid_sessions[,xitems]))
# VIF < 10  besser < 1
vifx(valid_sessions[,xitems])
# Tolerance > .2
1/vifx(valid_sessions[,xitems])

summary(resbestglm$BestModel)
