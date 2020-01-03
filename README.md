### Change detection with Sentinel-2
These scripts were developed to download, pre-process and analyze dense Sentinel-2 time series. 
The main purpose of using them is forest stand change detection.


<img src="milicz_DATA.jpg" width="500">

The downloading of Sentinel-2 imagery is described in Part1Download.r script. You can use two ways for finding and dowloading data - sen2r package or getSpatialData package.

Then, the pre-processing including sen2cor correction is in Part 2 script