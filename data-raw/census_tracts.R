library(sf)
library(dplyr)

# Census Tract boundaries

# 2020 (clipped to shoreline) --------------------------------------------

# download 2020 census tract shapefile from Department of Planning
ct20_url <- "https://s-media.nyc.gov/agencies/dcp/assets/files/zip/data-tools/bytes/nyct2020_23b.zip"
nycc_tracts_20 <- sf::read_sf(councildown::unzip_sf(ct20_url))  %>%
  st_transform("+proj=longlat +datum=WGS84") %>%
  mutate(
    # match county numbers with those from the acs data
    county = case_when(
      BoroCode == "1" ~ "061",
      BoroCode == "2" ~ "005",
      BoroCode == "3" ~ "047",
      BoroCode == "4" ~ "081",
      BoroCode == "5" ~ "085"
    ),
    # create GEO_ID to match acs data
    GEO_ID = paste0("1400000US36", county, CT2020)
  )
usethis::use_data(nycc_tracts_20, overwrite = TRUE)

# 2010 (clipped to shoreline) --------------------------------------------

ct10_url <- "https://s-media.nyc.gov/agencies/dcp/assets/files/zip/data-tools/bytes/nyct2010_23a.zip"
nycc_tracts_10 <- sf::read_sf(councildown::unzip_sf(ct10_url))  %>%
  st_transform("+proj=longlat +datum=WGS84") %>%
  mutate(
    # match county numbers with those from the acs data
    county = case_when(
      BoroCode == "1" ~ "061",
      BoroCode == "2" ~ "005",
      BoroCode == "3" ~ "047",
      BoroCode == "4" ~ "081",
      BoroCode == "5" ~ "085"
    ),
    # create GEO_ID to match acs data
    GEO_ID = paste0("1400000US36", county, CT2010)
  )
usethis::use_data(nycc_tracts_10, overwrite = TRUE)
