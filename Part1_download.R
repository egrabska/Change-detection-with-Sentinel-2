#remotes::install_github("ranghetti/sen2r")
#check_sen2r_deps()

library(sen2r)
library(sf)
setwd("D:/07_Paper3")
#-----------------search and download data using sen2r---------------
aoi = st_read("D:/07_Paper3/beskidy_zachodnie.shp")
time = as.Date(c("2018-04-10", "2018-10-30"))
s2_list = s2_list(spatial_extent = aoi,
                  time_interval = time,
                  max_cloud = 10)

print(s2_list)
as.vector(sort(sapply(names(s2_list), function(x) {
  strftime(safe_getMetadata(x,"nameinfo")$sensing_datetime)
})))

s2_download(s2_list[c(1,2,4)], outdir = "d:/07_Paper3")



#-------------search and download data using getSpatialData-------------
library(getSpatialData)
library(raster)
library(sf)
library(sp)
library(dplyr)
library(rlang)
set_aoi()
#view_aoi()
time_range =  c("2018-10-12", "2018-10-16")
platform = "Sentinel-2"
login_CopHub(username = "ewagrabska")

query = getSentinel_query(time_range, platform)
dane = query[which(query$cloudcoverpercentage < 10 & query$processinglevel == "Level-2A"),]
dane$title

getSentinel_preview(dane[6,], on_map = FALSE,show_aoi = TRUE)
set_archive("d:/02_Sentinel/paper3")
getSentinel_data(dane)

#unzipping 
setwd("path")
zips = list.files(pattern = "*.zip")
lapply(zips,unzip)


