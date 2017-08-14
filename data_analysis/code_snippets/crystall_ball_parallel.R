library(bestglm)
library(glmulti)
library(parallel)
library(foreach)
library(doParallel)
# Laoding data
source('prepare_data.R')


# Leap the data
items = c('implicite_general_acceptance',
          'apf_quantity',
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


# Calculate the number of cores
no_cores <- detectCores() - 1

# Initiate cluster
cl <- makeCluster(no_cores)
registerDoParallel(cl)
i = 1
foreach(1:no_cores, .export = "i")  %dopar%
  partobj <- glmulti(explicit_acceptance ~ ., data=sessions_for_regression, crit = "bic", 
                     name = "exhausting", 
                     plotty = F, 
                     report = F, 
                     level = 1, 
                     chunk = i, 
                     chunks = no_cores)
  write(partobj, file = "|object")
  i = i + 1
stopCluster(cl)
