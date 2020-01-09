#Hyper-parameters tunning

library(raster)
library(RStoolbox)
library(randomForest)
library(sf)
library(caret)
library(gbm)
training = st_read("D:/05_Przetworzenia/ref_class_binary.shp")
image = stack("d:/05_Przetworzenia/Klasyfikacja_binary/20160523_noclouds.tif")

#pre-processing
ptsamp = training %>% 
  st_sample(rep(5, nrow(training)), type = 'random') %>% 
  st_sf() %>%
  st_join(training, join=st_intersects)
img_sample = raster::extract(image, ptsamp) %>% as.data.frame()
img_sample$klasa = factor(ptsamp$klasa)
img_sample = img_sample[complete.cases(img_sample),]

fitControl = trainControl(method = "adaptive_cv", number = 10, repeats = 10, search = "random")
xgb_model = train(klasa~., data = img_sample, method = "xgbTree", trControl =  fitControl, 
                  verbose = FALSE, tuneLength = 100)


rf_model = train(klasa~., data = img_sample, method = "rf", trControl =  fitControl, 
                 verbose = FALSE, tuneLength = 100)

write.csv(xgb_model$results, "d:/05_Przetworzenia/Klasyfikacja_binary/xgb_hyperparameters100.csv")



#----------------------hyperparameters tuning-----------------
index = createDataPartition(img_sample$species_cd, p = 0.7, list = FALSE)
train = img_sample[index,] 
test = img_sample[-index,] 
#set-up cross-validation:
fitControl = trainControl(method = "repeatedcv", number = 3, repeats = 5)

#train rf model - tuneLength - how many different values to test
rf_model = train(species_cd~., data = img_sample, method = "rf", trControl =  fitControl, 
                 verbose = FALSE, tuneLength = 10)
svm_model = train(species_cd~., data = img_sample, method = "svmPoly", trControl =  fitControl, 
                  verbose = FALSE, tuneLength = 5)
gbm_model = train(species_cd~., data = img_sample, method = "gbm", trControl =  fitControl, 
                  verbose = FALSE)

#tuneGrid argument - when you specify your own values for hyperparameters - example from xgb:
my_grid = expand.grid(n.trees = c(100, 200, 250),
                      interaction.depth = c(1,4,6),
                      shrinkage = 0.1,
                      n.minobsinnode = 10)
gbm_model = train(species_cd~., data = img_sample, method = "gbm", trControl =  fitControl, 
                  verbose = FALSE, tuneGrid = big_grid)

big_grid = expand.grid(n.trees = seq(from = 10, to=300, by =50),
                       interaction.depth = seq(from=1, to=10, length.out = 6),
                       shrinkage = 0.1,
                       n.minobsinnode = 10)

#random search for hyperparameters - in trainControl search:
fitControl = trainControl(method = "repeatedcv", number = 3, repeats = 5, search = "random")
gbm_model = train(species_cd~., data = img_sample, method = "gbm", trControl =  fitControl, 
                  verbose = FALSE, tuneLength = 3) #error
nnet_model = train(species_cd~., data = img_sample, method = "nnet", trControl =  fitControl, 
                   verbose = FALSE, tuneLength = 3)


#adaptive resampling; arguments: method = "adaptive_cv" and search = "random"

fitControl = trainControl(method = "adaptive_cv", number = 3, repeats = 5, 
                          adaptive = list(min=2,
                                          alpha = 0.05,
                                          method = "gls",
                                          complete = TRUE),
                          search = "random")
svm_model = train(species_an~., data = img_sample, method = "svmLinear", trControl =  fitControl, 
                  verbose = FALSE, tuneLength = 10)

rf_model = train(species_an~., data = img_sample, method = "rf", trControl =  fitControl, 
                 verbose = FALSE, tuneLength = 100)


#xgbTree hyperparameter tuning
xgb_grid = expand.grid(gamma = 0, nrounds = 150, max_depth = 2,
                       eta = 0.3,
                       colsample_bytree = 0.8,
                       subsample = 0.75)

fitControl = trainControl(method = "repeatedcv", number = 3, repeats = 5, search = "random")
xgb_model = train(species_cd~., data = img_sample, method = "xgbTree", trControl =  fitControl, 
                  verbose = FALSE, tuneLength = 10)



fitControl = trainControl(method = "adaptive_cv", number = 3, repeats = 5, 
                          adaptive = list(min=2,
                                          alpha = 0.05,
                                          method = "gls",
                                          complete = TRUE),
                          search = "random")

svm_model = train(species_an~., data = img_sample, method = "svmLinear", trControl =  fitControl, 
                  verbose = FALSE, tuneLength = 10)

