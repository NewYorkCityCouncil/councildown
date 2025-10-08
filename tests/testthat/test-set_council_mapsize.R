# tests/testthat/test-set_council_mapsize.R

# Helper function to extract the CSS string injected by set_council_mapsize.
# The function uses htmlwidgets::prependContent, which adds a tagList to the
# map object's 'prepend' slot. We extract the <style> tag's content from there.
get_injected_css <- function(map) {
  # Ensure there is prepended content to check
  if (is.null(map$prepend) || length(map$prepend) == 0) {
    return(NA_character_)
  }
  # The structure is typically a tagList -> tags$style -> CSS string
  style_tag_content <- map$prepend[[1]]$children[[1]]
  return(style_tag_content)
}


test_that("set_council_mapsize input validation works", {
  skip_if_not_installed("leaflet")
  library(leaflet)
  m_orig <- leaflet()

  # Test for invalid map object
  expect_error(
    set_council_mapsize("not a map"),
    regexp = "Input 'map' must be a leaflet map object"
  )

  # Test for invalid layout argument
  expect_error(
    set_council_mapsize(m_orig, layout = "invalid_layout"),
    regexp = "'arg' should be one of"
  )
})


test_that("set_council_mapsize works with default 'full_screen' layout", {
  skip_if_not_installed("leaflet")
  library(leaflet)
  m_orig <- leaflet()
  m <- set_council_mapsize(m_orig) # Use default layout

  # The output should still be a leaflet object
  expect_s3_class(m, "leaflet")

  css <- get_injected_css(m)
  expect_type(css, "character")

  # Check for key properties of the full_screen CSS
  expect_true(grepl("overflow: hidden;", css, fixed = TRUE))
  expect_true(grepl(".html-widget, .leaflet-container", css, fixed = TRUE))
  expect_true(grepl("height: 100% !important;", css, fixed = TRUE))
})


test_that("set_council_mapsize creates correct CSS for directional layouts", {
  skip_if_not_installed("leaflet")
  library(leaflet)
  m_orig <- leaflet()

  # Test "right" layout
  m_right <- set_council_mapsize(m_orig, layout = "right")
  css_right <- get_injected_css(m_right)
  expect_true(grepl("width: 75% !important;", css_right, fixed = TRUE))
  expect_true(grepl("right: 0;", css_right, fixed = TRUE))
  expect_true(grepl("top: 0;", css_right, fixed = TRUE))
  expect_true(grepl("height: 100% !important;", css_right, fixed = TRUE))

  # Test "left" layout
  m_left <- set_council_mapsize(m_orig, layout = "left")
  css_left <- get_injected_css(m_left)
  expect_true(grepl("width: 75% !important;", css_left, fixed = TRUE))
  expect_true(grepl("left: 0;", css_left, fixed = TRUE))
  expect_true(grepl("top: 0;", css_left, fixed = TRUE))
  expect_true(grepl("height: 100% !important;", css_left, fixed = TRUE))

  # Test "top" layout
  m_top <- set_council_mapsize(m_orig, layout = "top")
  css_top <- get_injected_css(m_top)
  expect_true(grepl("height: 75% !important;", css_top, fixed = TRUE))
  expect_true(grepl("top: 0;", css_top, fixed = TRUE))
  expect_true(grepl("left: 0;", css_top, fixed = TRUE))
  expect_true(grepl("width: 100% !important;", css_top, fixed = TRUE))

  # Test "bottom" layout
  m_bottom <- set_council_mapsize(m_orig, layout = "bottom")
  css_bottom <- get_injected_css(m_bottom)
  expect_true(grepl("height: 75% !important;", css_bottom, fixed = TRUE))
  expect_true(grepl("bottom: 0;", css_bottom, fixed = TRUE))
  expect_true(grepl("left: 0;", css_bottom, fixed = TRUE))
  expect_true(grepl("width: 100% !important;", css_bottom, fixed = TRUE))
})



# Additional code to test set_council_mapsize directly in the console
setwd("~/Documents/councildown")
devtools::load_all()
library(leaflet)
# Base map object to reuse for tests
nyc_map_base <- leaflet() %>%
  setView(lng = -74.0060, lat = 40.7128, zoom = 10)
# --- Test 1: Default 'full_screen' layout ---
# Expected result: The map should fill the entire Viewer pane.
nyc_map_base %>%
  set_council_mapsize() %>%
  add_council_basemaps()
# --- Test 2: 'right' layout ---
# Expected result: The map should fill the right 75% of the Viewer pane.
nyc_map_base %>%
  set_council_mapsize(layout = "right") %>%
  add_council_basemaps()
# --- Test 3: 'top' layout ---
# Expected result: The map should fill the top 75% of the Viewer pane.
nyc_map_base %>%
  set_council_mapsize(layout = "top") %>%
  add_council_basemaps()
# --- Test 4: Integration with other councildown functions ---
# Expected result: A map with council districts filling the left 75% of the pane.
leaflet() %>% # Start fresh as addCouncilStyle sets its own view
  set_council_mapsize(layout = "left") %>%
  addCouncilStyle(add_dists = TRUE, dist_year = "2023") %>%
  add_council_basemaps(selection = c(1, 2))




















