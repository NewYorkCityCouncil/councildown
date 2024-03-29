library(polylabelr)
library(sf)
library(dplyr)
library(purrr)

# City Council District boundaries
# https://www.nyc.gov/site/planning/data-maps/open-data/bytes-archive.page

# 2023-2033 --------------------------------------------

cd_url <- "https://s-media.nyc.gov/agencies/dcp/assets/files/zip/data-tools/bytes/nycc_23b.zip"
nycc_cd_23 <- sf::read_sf(councildown::unzip_sf(cd_url))

nycc_cd_23 <- nycc_cd_23 %>%
  st_transform("+proj=longlat +datum=WGS84") %>%
  mutate(lab_coord = map(geometry, ~poi(st_coordinates(.), precision = .000001)),
         lab_x = map_dbl(lab_coord, "x"),
         lab_y = map_dbl(lab_coord, "y")) %>%
  rename(coun_dist = CounDist)
usethis::use_data(nycc_cd_23, overwrite = TRUE)

# 2013-2023 --------------------------------------------

cd_url <- "https://s-media.nyc.gov/agencies/dcp/assets/files/zip/data-tools/bytes/nycc_22c.zip"
nycc_cd_13 <- sf::read_sf(councildown::unzip_sf(cd_url))

nycc_cd_13 <- nycc_cd_13 %>%
  st_transform("+proj=longlat +datum=WGS84") %>%
  mutate(lab_coord = map(geometry, ~poi(st_coordinates(.), precision = .000001)),
         lab_x = map_dbl(lab_coord, "x"),
         lab_y = map_dbl(lab_coord, "y")) %>%
  rename(coun_dist = CounDist)
usethis::use_data(nycc_cd_13, overwrite = TRUE)
