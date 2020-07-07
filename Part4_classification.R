
#Classification for forest and non-forest areas
library(randomForest)
library(RStoolbox)
library(raster)
library(caTools)
library(kernlab)

#Random Forest classification: x - path to classified raster, y -path to reference in .shp, z =- path to outputs
RFclassification = function(x,y,z){ 
  ref = shapefile(y)
  set.seed(5)
  split = sample.split(ref$Classname, 0.7) #spliting into training and validation sets based on "Classname"
  training_set = subset(ref, split == TRUE)
  validation_set = subset(ref, split == FALSE)
  rf_grid = expand.grid(mtry = c(1,2,3,5,10)) #setting different parameters of mtry
  classification = superClass(stack(x), training_set, validation_set, responseCol = "classname",
                    model = "rf", mode = "classification", tuneGrid = rf_grid, ntree =500)
  writeRaster(classification$map, paste(z, "classification_RF.tif", sep=""), overwrite = TRUE) #saving classification map
  write.csv(classification$validation$performance$table, paste(z, "table_RF.csv", sep="")) #saving confusion matrix
  write.csv(classification$validation$performance$overall, paste(z, "overall_RF.csv", sep="")) #saving accuracy metrics
}




#by analogy - XGBoost classification and SVM below:


klasyfikacjaXGB = function(x,y,z){
  ref = shapefile(y)
  set.seed(5)
  split = sample.split(ref$Classname, 0.7)
  training_set = subset(ref, split == TRUE)
  validation_set = subset(ref, split == FALSE)
  xgb_grid = expand.grid(nrounds = 950, max_depth = 4, eta = 0.05815779, gamma = 1.759227, colsample_bytree =
                           0.3573189, min_child_weight = 1, subsample = 0.9479397) #these are example hyperparamters, how to tune them - check out another script
  classification = superClass(stack(x),  training_set, validation_set, responseCol = "Classname",
                    model = "xgbTree", mode = "classification", tuneGrid = xgb_grid)
  writeRaster(classification$map, paste(z, "classification_XGB.tif", sep=""), overwrite = TRUE) #saving classification map
  write.csv(classification$validation$performance$table, paste(z, "table_XGB.csv", sep="")) #saving confusion matrix
  write.csv(classification$validation$performance$overall, paste(z, "overall_XGB.csv", sep="")) #saving accuracy metrics
}



klasyfikacjaSVM = function(x,y,z){
  ref = shapefile(y)
  set.seed(5)
  split = sample.split(ref$Classname, 0.7)
  training_set = subset(ref, split == TRUE)
  validation_set = subset(ref, split == FALSE)
  SVM_grid = expand.grid(degree = 2, scale = 1.8996, C = 9.243558) #these are example hyperparamters, how to tune them - check out another script
  classification = superClass(stack(x),  training_set, validation_set, responseCol = "Classname",
                    model = "svmPoly", mode = "classification", tuneGrid = SVM_grid)
  writeRaster(classification$map, paste(z, "classification_SVM.tif", sep=""), overwrite = TRUE) #saving classification map
  write.csv(classification$validation$performance$table, paste(z, "table_SVM.csv", sep="")) #saving confusion matrix
  write.csv(classification$validation$performance$overall, paste(z, "overall_SVM.csv", sep="")) #saving accuracy metrics
}
