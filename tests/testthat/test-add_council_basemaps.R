# tests/testthat/test-add_council_basemaps.R

# Helper function to get leaflet calls of a specific method
get_leaflet_calls <- function(map, method_name) {
  Filter(function(x) x$method == method_name, map$x$calls)
}

# Helper to get provider names/URLs from the function's catalog
.test_council_basemap_catalog <- list(
  `1` = list(default_name = "Light", provider_call = quote(leaflet::providers$CartoDB.Positron)),
  `2` = list(default_name = "Dark", provider_call = quote(leaflet::providers$CartoDB.DarkMatter)),
  `3` = list(default_name = "Streets", provider_call = quote(leaflet::providers$CartoDB.Voyager)),
  `4` = list(default_name = "Physical", provider_call = quote(leaflet::providers$Esri.WorldTopoMap)),
  `5` = list(default_name = "Satellite", provider_call = quote(leaflet::providers$Esri.WorldImagery)),
  `6` = list(default_name = "Basic", provider_call = quote(leaflet::providers$Esri.WorldGrayCanvas))
)

get_provider_url <- function(id) {
  eval(.test_council_basemap_catalog[[as.character(id)]]$provider_call)
}
get_default_name <- function(id) {
  .test_council_basemap_catalog[[as.character(id)]]$default_name
}


test_that("add_council_basemaps works with default settings", {
  skip_if_not_installed("leaflet")
  library(leaflet)

  m_orig <- leaflet()
  m <- add_council_basemaps(m_orig)

  provider_calls <- get_leaflet_calls(m, "addProviderTiles")
  control_calls <- get_leaflet_calls(m, "addLayersControl")

  expect_s3_class(m, "leaflet")
  expect_length(provider_calls, 6)

  expected_default_names <- sapply(1:6, get_default_name)
  added_group_names_raw <- lapply(provider_calls, function(call) call$args[[3]])
  added_group_names <- unlist(Filter(Negate(is.null), added_group_names_raw))

  expect_true(all(expected_default_names %in% added_group_names))
  expect_equal(length(added_group_names), length(expected_default_names),
               info = "Number of non-NULL group names should match expected.")


  expect_length(control_calls, 1)
  control_args <- control_calls[[1]]$args
  expect_equal(length(control_args[[1]]), 6) # baseGroups
  expect_true(all(expected_default_names %in% control_args[[1]])) # baseGroups

  # Options are the 3rd argument
  layers_options_list <- control_args[[3]]
  expect_equal(layers_options_list$position, "bottomleft")
  expect_true(layers_options_list$collapsed)
})

test_that("add_council_basemaps works with specific selection", {
  skip_if_not_installed("leaflet")
  library(leaflet)

  m_orig <- leaflet()
  selection <- c(1, 5)
  m <- add_council_basemaps(m_orig, selection = selection)

  provider_calls <- get_leaflet_calls(m, "addProviderTiles")
  control_calls <- get_leaflet_calls(m, "addLayersControl")

  expect_length(provider_calls, 2)
  expect_equal(provider_calls[[1]]$args[[1]], get_provider_url(1))
  expect_equal(provider_calls[[1]]$args[[3]], get_default_name(1))
  expect_equal(provider_calls[[2]]$args[[1]], get_provider_url(5))
  expect_equal(provider_calls[[2]]$args[[3]], get_default_name(5))

  expect_length(control_calls, 1)
  control_args <- control_calls[[1]]$args
  expect_equal(control_args[[1]], c(get_default_name(1), get_default_name(5)))
})

test_that("add_council_basemaps respects selection order and handles duplicates", {
  skip_if_not_installed("leaflet")
  library(leaflet)

  m1 <- add_council_basemaps(leaflet(), selection = c(5, 1, 5))
  control_args1 <- get_leaflet_calls(m1, "addLayersControl")[[1]]$args
  expect_equal(control_args1[[1]], c(get_default_name(1), get_default_name(5)))

  m2 <- add_council_basemaps(leaflet(), selection = c(1, 5, 1))
  control_args2 <- get_leaflet_calls(m2, "addLayersControl")[[1]]$args
  expect_equal(control_args2[[1]], c(get_default_name(5), get_default_name(1)))
})


test_that("add_council_basemaps works with custom names", {
  skip_if_not_installed("leaflet")
  library(leaflet)

  m_orig <- leaflet()
  selection <- c(2, 4)
  custom <- c("My Dark Map", "My Physical Map")
  m <- add_council_basemaps(m_orig, selection = selection, custom_names = custom)

  provider_calls <- get_leaflet_calls(m, "addProviderTiles")
  control_calls <- get_leaflet_calls(m, "addLayersControl")

  expect_length(provider_calls, 2)
  expect_equal(provider_calls[[1]]$args[[3]], custom[1])
  expect_equal(provider_calls[[2]]$args[[3]], custom[2])

  expect_length(control_calls, 1)
  control_args <- control_calls[[1]]$args
  expect_equal(control_args[[1]], custom)
})

test_that("add_council_basemaps handles control options", {
  skip_if_not_installed("leaflet")
  library(leaflet)

  m_orig <- leaflet()
  m <- add_council_basemaps(m_orig, selection = 1,
                            control_position = "topright", control_collapsed = FALSE)

  control_calls <- get_leaflet_calls(m, "addLayersControl")
  expect_length(control_calls, 1)
  control_args <- control_calls[[1]]$args
  layers_options_list <- control_args[[3]] # MODIFIED: Options are the 3rd argument
  expect_equal(layers_options_list$position, "topright")
  expect_false(layers_options_list$collapsed)
})

test_that("add_council_basemaps input validation works", {
  skip_if_not_installed("leaflet")
  library(leaflet)
  m_orig <- leaflet()

  expect_error(add_council_basemaps("not a map"),
               "Input 'map' must be a leaflet map object")
  expect_error(add_council_basemaps(m_orig, selection = "a"),
               "'selection' must be a numeric vector.")
  expect_error(add_council_basemaps(m_orig, selection = c(1,2), custom_names = "one"),
               "'custom_names' must be a character vector with 2 elements")
  expect_error(add_council_basemaps(m_orig, selection = 1, custom_names = 123),
               "'custom_names' must be a character vector with 1 elements")
  expect_error(add_council_basemaps(m_orig, control_position = 123),
               "'control_position' must be a single character string.")
  expect_error(add_council_basemaps(m_orig, control_position = c("a", "b")),
               "'control_position' must be a single character string.")
  expect_error(add_council_basemaps(m_orig, control_collapsed = "TRUE"),
               "'control_collapsed' must be a single logical value")
  expect_error(add_council_basemaps(m_orig, control_collapsed = NA),
               regexp = "'control_collapsed' must be a single logical value (TRUE or FALSE), not NA.",
               fixed = TRUE)
})

test_that("add_council_basemaps handles empty or invalid numeric selections", {
  skip_if_not_installed("leaflet")
  library(leaflet)
  m_orig <- leaflet()

  m_empty <- add_council_basemaps(m_orig, selection = numeric(0))
  expect_length(get_leaflet_calls(m_empty, "addProviderTiles"), 0)
  expect_length(get_leaflet_calls(m_empty, "addLayersControl"), 0)
  expect_equal(m_empty$x$calls, m_orig$x$calls)

  expect_error(
    add_council_basemaps(m_orig, selection = c(99, 100)),
    "Invalid 'selection'. Choose numbers between 1 and 6."
  )
  expect_error(
    add_council_basemaps(m_orig, selection = 0),
    "Invalid 'selection'. Choose numbers between 1 and 6."
  )
  expect_error(
    add_council_basemaps(m_orig, selection = 7),
    "Invalid 'selection'. Choose numbers between 1 and 6."
  )
  expect_error(
    add_council_basemaps(m_orig, selection = c(1, 99, 2)),
    "Invalid 'selection'. Choose numbers between 1 and 6."
  )
  expect_error(
    add_council_basemaps(m_orig, selection = c(1, NA_real_)),
    "Invalid 'selection'. Choose numbers between 1 and 6."
  )
  expect_error(
    add_council_basemaps(m_orig, selection = c(1, NA, 2)),
    "Invalid 'selection'. Choose numbers between 1 and 6."
  )
})


test_that("custom_names order matches selection order", {
  skip_if_not_installed("leaflet")
  library(leaflet)

  m_orig <- leaflet()
  selection <- c(5, 1)
  custom <- c("My Satellite", "My Light")
  m <- add_council_basemaps(m_orig, selection = selection, custom_names = custom)

  provider_calls <- get_leaflet_calls(m, "addProviderTiles")
  control_calls <- get_leaflet_calls(m, "addLayersControl")

  expect_length(provider_calls, 2)
  expect_equal(provider_calls[[1]]$args[[1]], get_provider_url(5))
  expect_equal(provider_calls[[1]]$args[[3]], custom[1])
  expect_equal(provider_calls[[2]]$args[[1]], get_provider_url(1))
  expect_equal(provider_calls[[2]]$args[[3]], custom[2])

  expect_length(control_calls, 1)
  control_args <- control_calls[[1]]$args
  expect_equal(control_args[[1]], custom)
})


# Additional code to test add_council_basemaps directly in the console
# setwd("~/Documents/councildown")
# devtools::load_all()
# library(leaflet)
# # Base map centered on NYC
# nyc_map_base <- leaflet() %>%
#   setView(lng = -74.0060, lat = 40.7128, zoom = 10)
# # Test 1: Default settings
# nyc_map_base %>%
#   add_council_basemaps()
# # Test 2: Specific selection
# nyc_map_base %>%
#   add_council_basemaps(selection = c(1, 5))
# # Test 3: Custom names and control options
# nyc_map_base %>%
#   add_council_basemaps(selection = c(2, 4),
#                        custom_names = c("My Dark Theme", "Topo View"),
#                        control_position = "topright",
#                        control_collapsed = FALSE)
