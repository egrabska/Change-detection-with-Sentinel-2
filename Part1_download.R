#remotes::install_github("ranghetti/sen2r")
#check_sen2r_deps()

library(sen2r)
library(raster)
library(RStoolbox)
library(sf)
setwd("D:/07_Paper3")
#-----------------search and download data---------------
aoi = st_read("D:/07_Paper3/Bircza_granice.shp")
time = as.Date(c("2018-08-30", "2018-08-30"))
s2_list = s2_list(spatial_extent = aoi,
                  time_interval = time,
                  max_cloud = 10)

print(s2_list)
as.vector(sort(sapply(names(s2_list), function(x) {
  strftime(safe_getMetadata(x,"nameinfo")$sensing_datetime)
})))

s2_download(s2_list[c(1,2,4)], outdir = "d:/07_Paper3")
