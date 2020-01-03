#sen2cor correction (from TOA to BOA reflectance) - for many directories (folders) 

dirs = list.dirs("path")
dirs = dirs[grepl("*.SAFE$", dirs)]
dirs_toa = dirs[grepl("*MSIL1C*", dirs)]
lapply(dirs_toa[2], sen2cor)


#producing one raster in .tiff format from Sentinel-2 bands 
dirs = list.dirs("path")
dirs = dirs[grepl("*.SAFE$", dirs)]

lapply(dirs, s2_translate, format="GTiff")