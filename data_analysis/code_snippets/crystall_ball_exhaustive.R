# Inspired by http://rpubs.com/kaz_yos/exhaustive

# Laoding data
source('prepare_data.R')
library('parallel')

# Leap the data
predictors = c('implicite_general_acceptance',
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
          'car_category')
outcome = c('explicit_acceptance')
dataset <- valid_sessions

## Create list of models
list.of.models <- mclapply(seq_along((predictors)), function(n) {
  
  left.hand.side  <- outcome
  right.hand.side <- apply(X = combn(predictors, n), MARGIN = 2, paste, collapse = " + ")
  
  paste(left.hand.side, right.hand.side, sep = "  ~  ")
}, mc.cores=parallel::detectCores())
## Convert to a vector
vector.of.models <- unlist(list.of.models)

start.time <- Sys.time()

## Fit coxph to all models
list.of.fits <- mclapply(vector.of.models, function(x) {
  formula    <- as.formula(x)
  fit        <- glm(formula, data = dataset)
  result.BIC <- extractAIC(fit, k = log(nrow(dataset)))
  
  data.frame(num.predictors = result.BIC[1],
             BIC            = result.BIC[2],
             model          = x)
}, mc.cores=parallel::detectCores())
end.time <- Sys.time()
time.taken <- end.time - start.time
time.taken

## Collapse to a data frame
list.of.fits.sorted <- list.of.fits[order(sapply(list.of.fits,'[[',2))]
myBestglm <- glm(as.character(list.of.fits.sorted[[1]][3]$model), data=dataset)
r2 <- 1- (myBestglm$deviance/myBestglm$null.deviance)
