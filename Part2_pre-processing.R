library(sen2r)
#--1--sen2cor correction (from TOA to BOA reflectance) - for many directories (folders) 

dirs = list.dirs("path")
dirs = dirs[grepl("*.SAFE$", dirs)]
dirs_toa = dirs[grepl("*MSIL1C*", dirs)]
lapply(dirs_toa[2], sen2cor)


#--2--producing one raster in .tiff format from Sentinel-2 bands 
dirs = list.dirs("path")
dirs = dirs[grepl("*.SAFE$", dirs)]

lapply(dirs, s2_translate, format="GTiff")

#--3--calculating indices
sort(list_indices("name", all=TRUE))

#for single image
s2_calcindices("path", 
               indices = c("NDVI"), subdirs = FALSE,
               parallel = TRUE)

#for many images
images= list.files(path = "", pattern ="*BOA_10.tif$*", full.names = TRUE)
lapply(images, s2_calcindices, indices = c("MSI", "SLAVI"), subdirs = TRUE, parallel = TRUE)

