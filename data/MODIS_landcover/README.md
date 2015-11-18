Data downloaded from http://glcf.umd.edu/data/lc/ on 18 November 2015.



# Overview

Global Mosaics of the standard MODIS land cover type data product (MCD12Q1) in the IGBP Land Cover Type Classification are reprojected into geographic coordinates of latitude and longitude on the WGS 1984 coordinate reference system (EPSG: 4326). The data set boundaries are -180.0° <= longitude <= 180.0°; -64.0° <= latitude <= 84.0°. The data are organized as an array of values uniformly spaced across latitude and longitude with the indexed as [0, 0] at 84.0° latitude, -180.0° longitude.

Spatially aggregated data for each year in the period 2001–2012 are available at two spatial resolutions:

5' x 5' resolution comprising 1776 rows x 4320 columns at a geographic pixel size of approximately 0.083333°; and
0.5° x 0.5° resolution comprising 296 rows x 720 columns of 0.5° pixels.
The global land cover data sets are available as GeoTIFF format files (*.tif) with embedded metadata or as ESRI ASCII Grid format files (*.asc) with limited metadata in header lines. Native resolution data in the GLCF tile framework are available as GeoTIFF format files (*.tif).

# Code Values

Value	|	Label
------- | -----------
0	|	Water
1	|	Evergreen Needleleaf forest
2	|	Evergreen Broadleaf forest
3	|	Deciduous Needleleaf forest
4	|	Deciduous Broadleaf forest
5	|	Mixed forest
6	|	Closed shrublands
7	|	Open shrublands
8	|	Woody savannas
9	|	Savannas
10	|	Grasslands
11	|	Permanent wetlands
12	|	Croplands
13	|	Urban and built-up
14	|	Cropland/Natural vegetation mosaic
15	|	Snow and ice
16	|	Barren or sparsely vegetated
254	|	Unclassified
255	|	Fill Value

 
# How to Cite This Data Set

Data set development attribution:
Channan, S., K. Collins, and W. R. Emanuel. 2014. Global mosaics of the standard MODIS land cover type data. University of Maryland and the Pacific Northwest National Laboratory, College Park, Maryland, USA.

MODIS standard data product attribution:
Friedl, M.A., D. Sulla-Menashe, B. Tan, A. Schneider, N. Ramankutty, A. Sibley and X. Huang (2010), MODIS Collection 5 global land cover: Algorithm refinements and characterization of new datasets, 2001-2012, Collection 5.1 IGBP Land Cover, Boston University, Boston, MA, USA.

Intellectual Property Rights
University of Maryland, Department of Geography and NASA; use is free to all if acknowledgement is made. UMD and NASA hold ultimate copyright.

# Source

Source for this dataset is the Global Land Cover Facility, www.landcover.org.