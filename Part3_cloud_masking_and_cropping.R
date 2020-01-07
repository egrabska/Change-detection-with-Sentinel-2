library(raster)
#Cloud masking & cropping to the area of study

cloud_masking = function(x){
  scl = raster(list.files("path to Sentinel-2 .SAFE folder",
                          pattern = glob2rx(paste0("*",x,"*","SCL_20m.jp2")), recursive = TRUE, full.names=TRUE))
  img = stack(list.files("path to the folder with Sentinel-2 .tif raster",
                         pattern = glob2rx(paste0("*",x,"*tif")), recursive = TRUE, full.names = TRUE))
  ex = c(xmin, xmax, ymin, ymax) #define your extent
  scl_crop = crop(scl, ex)
  img_crop = crop(img, ex)
  resamp_scl = resample(scl_crop, img_crop, method="ngb")
  no_clouds_mask = resamp_scl != 8 & resamp_scl != 3 & resamp_scl != 9
  img_no_clouds = overlay(img_crop, no_clouds_mask, fun = function(y, z) {
    y[z==0] = NA
    return(y)
  })
  writeRaster(img_no_clouds, paste("path", x, "_noclouds.tif", sep=""), overwrite = TRUE)
}

#run fuction with desirable single image date, e.g.:
cloud_masking("20191013")

#or create a list of dates and use lapply (in my case the single rasters end with "BOA_10.tif" so I put that as a pattern:
names = substr(list.files("path to folder with Sentinel2 .tiff rasters", pattern = glob2rx("*BOA_10.tif")), 7, 14)
lapply(names, cloud_masking)



