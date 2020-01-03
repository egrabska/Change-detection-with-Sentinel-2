#sen2cor correction (from TOA to BOA reflectance)


setwd("D:/02_Sentinel/paper3/get_data/Sentinel-2")
dirs = list.dirs()
dirs = dirs[grepl("*.SAFE$", dirs)]
dirs_toa = dirs[grepl("*MSIL1C*", dirs)]
lapply(dirs_toa[2], sen2cor)
