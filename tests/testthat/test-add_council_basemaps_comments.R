# tests/testthat/test-add_council_basemaps.R

# --- Helper Functions: Reusable code to make tests cleaner and more readable ---

# Helper function to extract specific types of operations from a leaflet map object.
# Leaflet map objects store a sequence of operations (e.g., adding tiles, adding controls)
# in map$x$calls. This function filters that list.
# - map: The leaflet map object to inspect.
# - method_name: The string name of the leaflet method we're looking for (e.g., "addProviderTiles").
get_leaflet_calls <- function(map, method_name) {
  # Filter goes through each element in map$x$calls (let's call it 'x').
  # It keeps 'x' if x$method matches the provided method_name.
  Filter(function(x) x$method == method_name, map$x$calls)
}

# A local copy of the basemap catalog used within the add_council_basemaps function.
# This is defined here in the test file to:
# 1. Avoid depending on the internal (unexported) catalog from the package directly in tests.
# 2. Provide a stable reference for what the expected provider URLs and default names are.
# The `quote()` function is used to store the R expressions for provider tiles without evaluating them immediately.
# The `.` prefix for the variable name (.test_council_basemap_catalog) is a common convention
# for objects intended for internal use within this test file or test environment.
.test_council_basemap_catalog <- list(
  `1` = list(default_name = "Light", provider_call = quote(leaflet::providers$CartoDB.Positron)),
  `2` = list(default_name = "Dark", provider_call = quote(leaflet::providers$CartoDB.DarkMatter)),
  `3` = list(default_name = "Streets", provider_call = quote(leaflet::providers$CartoDB.Voyager)),
  `4` = list(default_name = "Physical", provider_call = quote(leaflet::providers$Esri.WorldTopoMap)),
  `5` = list(default_name = "Satellite", provider_call = quote(leaflet::providers$Esri.WorldImagery)),
  `6` = list(default_name = "Basic", provider_call = quote(leaflet::providers$Esri.WorldGrayCanvas))
)

# Helper function to retrieve the expected provider tile URL/object for a given basemap ID.
# It uses the local .test_council_basemap_catalog.
# - id: The numeric ID (1-6) of the basemap.
get_provider_url <- function(id) {
  # Converts id to character to match the names in the list (e.g., "1").
  # Accesses the 'provider_call' element for that ID.
  # eval() executes the quoted R expression to get the actual provider tile object.
  eval(.test_council_basemap_catalog[[as.character(id)]]$provider_call)
}

# Helper function to retrieve the default name for a given basemap ID.
# It uses the local .test_council_basemap_catalog.
# - id: The numeric ID (1-6) of the basemap.
get_default_name <- function(id) {
  # Converts id to character to match the names in the list.
  # Accesses the 'default_name' element for that ID.
  .test_council_basemap_catalog[[as.character(id)]]$default_name
}

# --- Test Block 1: Testing default behavior ---
# test_that() defines a block of related tests.
# The string describes what this block of tests is verifying.
test_that("add_council_basemaps works with default settings", {
  # skip_if_not_installed checks if a package is available. If not, this test block is skipped.
  # This is crucial for dependencies that might not be installed everywhere (e.g., on CRAN).
  skip_if_not_installed("leaflet")
  # library() loads the specified package, making its functions available for this test block.
  library(leaflet)

  # --- Setup: Prepare inputs for the function call ---
  # Create a basic, empty leaflet map object. This is the input to our function.
  m_orig <- leaflet()
  # Call the function we are testing (add_council_basemaps) with the original map.
  # Since no 'selection' is provided, it should use default behavior (add all 6 basemaps).
  m <- add_council_basemaps(m_orig)

  # --- Retrieve results for assertions ---
  # Use our helper function to get all calls made to 'addProviderTiles' on the modified map 'm'.
  provider_calls <- get_leaflet_calls(m, "addProviderTiles")
  # Use our helper function to get all calls made to 'addLayersControl' on the modified map 'm'.
  control_calls <- get_leaflet_calls(m, "addLayersControl")

  # --- Assertions: Check if the outcomes are as expected ---
  # expect_s3_class checks if the object 'm' is of the S3 class "leaflet".
  # This confirms the function returns a valid leaflet map object.
  expect_s3_class(m, "leaflet")
  # expect_length checks if the 'provider_calls' list has 6 elements.
  # This confirms that 6 basemaps (provider tiles) were added by default.
  expect_length(provider_calls, 6)

  # Prepare the list of expected default names for the basemaps.
  # sapply applies the 'get_default_name' helper function to numbers 1 through 6.
  expected_default_names <- sapply(1:6, get_default_name)
  # Extract the group names actually used when 'addProviderTiles' was called.
  # The group name is typically the 3rd argument (args[[3]]) in the addProviderTiles call.
  added_group_names_raw <- lapply(provider_calls, function(call) call$args[[3]])
  # Unlist and remove any NULLs to get a clean vector of group names.
  added_group_names <- unlist(Filter(Negate(is.null), added_group_names_raw))

  # expect_true checks if the provided condition is TRUE.
  # Here, it checks if all 'expected_default_names' are present in the 'added_group_names'.
  # Order doesn't matter for this check, just presence.
  expect_true(all(expected_default_names %in% added_group_names))
  # expect_equal checks if two values are equal.
  # Here, it checks if the number of added group names matches the number of expected names.
  # The 'info' argument provides an additional message if this test fails, aiding debugging.
  expect_equal(length(added_group_names), length(expected_default_names),
               info = "Number of non-NULL group names should match expected.")

  # Check the layers control.
  # expect_length checks if 'control_calls' has 1 element (meaning addLayersControl was called once).
  expect_length(control_calls, 1)
  # Extract the arguments passed to the first (and only) 'addLayersControl' call.
  control_args <- control_calls[[1]]$args
  # expect_equal checks if the first argument to addLayersControl (baseGroups) has 6 elements.
  expect_equal(length(control_args[[1]]), 6) # baseGroups
  # expect_true checks if all 'expected_default_names' are present in the 'baseGroups' argument of the control.
  expect_true(all(expected_default_names %in% control_args[[1]])) # baseGroups

  # Check the options passed to addLayersControl.
  # The options list is the 3rd argument (args[[3]]) to addLayersControl.
  layers_options_list <- control_args[[3]]
  # expect_equal checks if the 'position' option is "bottomleft" (the default).
  expect_equal(layers_options_list$position, "bottomleft")
  # expect_true checks if the 'collapsed' option is TRUE (the default).
  expect_true(layers_options_list$collapsed)
}) # End of "default settings" test_that block

# --- Test Block 2: Testing behavior with a specific selection of basemaps ---
test_that("add_council_basemaps works with specific selection", {
  # Standard setup: skip if leaflet not installed, load leaflet.
  skip_if_not_installed("leaflet")
  library(leaflet)

  # --- Setup ---
  # Create an empty leaflet map.
  m_orig <- leaflet()
  # Define a specific selection of basemaps (1 and 5).
  selection <- c(1, 5)
  # Call add_council_basemaps with this specific selection.
  m <- add_council_basemaps(m_orig, selection = selection)

  # --- Retrieve results ---
  # Get the calls to addProviderTiles and addLayersControl.
  provider_calls <- get_leaflet_calls(m, "addProviderTiles")
  control_calls <- get_leaflet_calls(m, "addLayersControl")

  # --- Assertions for Provider Tiles ---
  # expect_length: Check that exactly 2 provider tiles were added.
  expect_length(provider_calls, 2)
  # expect_equal: Check that the first provider tile added is the correct one (ID 1, "Light").
  # provider_calls[[1]]$args[[1]] is the actual tile provider object/URL.
  # provider_calls[[1]]$args[[3]] is the group name for this tile.
  expect_equal(provider_calls[[1]]$args[[1]], get_provider_url(1))
  expect_equal(provider_calls[[1]]$args[[3]], get_default_name(1))
  # expect_equal: Check that the second provider tile added is the correct one (ID 5, "Satellite").
  expect_equal(provider_calls[[2]]$args[[1]], get_provider_url(5))
  expect_equal(provider_calls[[2]]$args[[3]], get_default_name(5))

  # --- Assertions for Layers Control ---
  # expect_length: Check that addLayersControl was called once.
  expect_length(control_calls, 1)
  # Extract arguments from the addLayersControl call.
  control_args <- control_calls[[1]]$args
  # expect_equal: Check that the 'baseGroups' argument in the control matches the names of the selected basemaps, in order.
  expect_equal(control_args[[1]], c(get_default_name(1), get_default_name(5)))
}) # End of "specific selection" test_that block

# --- Test Block 3: Testing how selection order and duplicate selections are handled ---
test_that("add_council_basemaps respects selection order and handles duplicates", {
  # Standard setup.
  skip_if_not_installed("leaflet")
  library(leaflet)

  # --- Scenario 1: Test with selection = c(5, 1, 5) ---
  # Call add_council_basemaps. The function should use unique values from selection,
  # preserving the order of the first occurrence (so 5 then 1).
  # However, the current implementation `rev(unique(rev(selection)))` will result in 1 then 5.
  m1 <- add_council_basemaps(leaflet(), selection = c(5, 1, 5))
  # Get the arguments of the addLayersControl call.
  control_args1 <- get_leaflet_calls(m1, "addLayersControl")[[1]]$args
  # expect_equal: Check that the baseGroups in the control are "Light" (1) then "Satellite" (5).
  expect_equal(control_args1[[1]], c(get_default_name(1), get_default_name(5)))

  # --- Scenario 2: Test with selection = c(1, 5, 1) ---
  # The function should use unique values, preserving the order of the first occurrence.
  # `rev(unique(rev(selection)))` will result in 5 then 1.
  m2 <- add_council_basemaps(leaflet(), selection = c(1, 5, 1))
  # Get the arguments of the addLayersControl call.
  control_args2 <- get_leaflet_calls(m2, "addLayersControl")[[1]]$args
  # expect_equal: Check that the baseGroups in the control are "Satellite" (5) then "Light" (1).
  expect_equal(control_args2[[1]], c(get_default_name(5), get_default_name(1)))
}) # End of "selection order and duplicates" test_that block


# --- Test Block 4: Testing behavior with custom names for basemaps ---
test_that("add_council_basemaps works with custom names", {
  # Standard setup.
  skip_if_not_installed("leaflet")
  library(leaflet)

  # --- Setup ---
  m_orig <- leaflet()
  # Select basemaps 2 ("Dark") and 4 ("Physical").
  selection <- c(2, 4)
  # Provide custom names for these selections.
  custom <- c("My Dark Map", "My Physical Map")
  # Call the function with custom names.
  m <- add_council_basemaps(m_orig, selection = selection, custom_names = custom)

  # --- Retrieve results ---
  provider_calls <- get_leaflet_calls(m, "addProviderTiles")
  control_calls <- get_leaflet_calls(m, "addLayersControl")

  # --- Assertions for Provider Tiles with Custom Names ---
  # expect_length: Ensure 2 provider tiles were added.
  expect_length(provider_calls, 2)
  # expect_equal: Check that the group name for the first added tile matches the first custom name.
  expect_equal(provider_calls[[1]]$args[[3]], custom[1])
  # expect_equal: Check that the group name for the second added tile matches the second custom name.
  expect_equal(provider_calls[[2]]$args[[3]], custom[2])

  # --- Assertions for Layers Control with Custom Names ---
  # expect_length: Ensure addLayersControl was called once.
  expect_length(control_calls, 1)
  # Extract arguments from the addLayersControl call.
  control_args <- control_calls[[1]]$args
  # expect_equal: Check that the 'baseGroups' in the control are exactly the custom names provided, in order.
  expect_equal(control_args[[1]], custom)
}) # End of "custom names" test_that block

# --- Test Block 5: Testing if control options (position, collapsed) are handled correctly ---
test_that("add_council_basemaps handles control options", {
  # Standard setup.
  skip_if_not_installed("leaflet")
  library(leaflet)

  # --- Setup ---
  m_orig <- leaflet()
  # Call the function, selecting one basemap, and specifying non-default control options.
  m <- add_council_basemaps(m_orig, selection = 1,
                            control_position = "topright", control_collapsed = FALSE)

  # --- Retrieve results ---
  # Get the addLayersControl calls.
  control_calls <- get_leaflet_calls(m, "addLayersControl")

  # --- Assertions for Control Options ---
  # expect_length: Ensure addLayersControl was called once.
  expect_length(control_calls, 1)
  # Extract arguments from the addLayersControl call.
  control_args <- control_calls[[1]]$args
  # The options list is the 3rd argument.
  layers_options_list <- control_args[[3]]
  # expect_equal: Check if the 'position' option in the control is "topright" as specified.
  expect_equal(layers_options_list$position, "topright")
  # expect_false: Check if the 'collapsed' option in the control is FALSE as specified.
  expect_false(layers_options_list$collapsed)
}) # End of "control options" test_that block

# --- Test Block 6: Testing input validation for various arguments ---
# This block ensures the function throws errors when given invalid inputs.
test_that("add_council_basemaps input validation works", {
  # Standard setup.
  skip_if_not_installed("leaflet")
  library(leaflet)
  m_orig <- leaflet() # A valid map object for some tests.

  # expect_error checks that the code inside it throws an error.
  # The second argument to expect_error is the expected error message (or a part of it / a regex).
  # Test with an invalid 'map' argument.
  expect_error(add_council_basemaps("not a map"),
               "Input 'map' must be a leaflet map object")
  # Test with an invalid 'selection' argument (character instead of numeric).
  expect_error(add_council_basemaps(m_orig, selection = "a"),
               "'selection' must be a numeric vector.")
  # Test with 'custom_names' having incorrect length.
  expect_error(add_council_basemaps(m_orig, selection = c(1,2), custom_names = "one"),
               "'custom_names' must be a character vector with 2 elements")
  # Test with 'custom_names' having incorrect type.
  expect_error(add_council_basemaps(m_orig, selection = 1, custom_names = 123),
               "'custom_names' must be a character vector with 1 elements")
  # Test with an invalid 'control_position' argument (numeric instead of character).
  expect_error(add_council_basemaps(m_orig, control_position = 123),
               "'control_position' must be a single character string.")
  # Test with an invalid 'control_position' argument (vector instead of single string).
  expect_error(add_council_basemaps(m_orig, control_position = c("a", "b")),
               "'control_position' must be a single character string.")
  # Test with an invalid 'control_collapsed' argument (character instead of logical).
  expect_error(add_council_basemaps(m_orig, control_collapsed = "TRUE"),
               "'control_collapsed' must be a single logical value")
  # Test with 'control_collapsed' as NA.
  # 'regexp' is used to match the error message. 'fixed = TRUE' means the string is matched literally, not as a regex.
  expect_error(add_council_basemaps(m_orig, control_collapsed = NA),
               regexp = "'control_collapsed' must be a single logical value (TRUE or FALSE), not NA.",
               fixed = TRUE)
}) # End of "input validation" test_that block

# --- Test Block 7: Testing handling of empty or invalid numeric selections ---
test_that("add_council_basemaps handles empty or invalid numeric selections", {
  # Standard setup.
  skip_if_not_installed("leaflet")
  library(leaflet)
  m_orig <- leaflet()

  # --- Test with an empty numeric selection ---
  # Call the function with an empty numeric vector for 'selection'.
  m_empty <- add_council_basemaps(m_orig, selection = numeric(0))
  # expect_length: No provider tiles should be added.
  expect_length(get_leaflet_calls(m_empty, "addProviderTiles"), 0)
  # expect_length: No layers control should be added.
  expect_length(get_leaflet_calls(m_empty, "addLayersControl"), 0)
  # expect_equal: The map's call list should be unchanged from the original.
  expect_equal(m_empty$x$calls, m_orig$x$calls)

  # --- Test with various invalid numeric selections ---
  # These should all throw an error because the numbers are outside the valid range (1-6).
  expect_error(
    add_council_basemaps(m_orig, selection = c(99, 100)), # Numbers too high
    "Invalid 'selection'. Choose numbers between 1 and 6."
  )
  expect_error(
    add_council_basemaps(m_orig, selection = 0), # Number too low
    "Invalid 'selection'. Choose numbers between 1 and 6."
  )
  expect_error(
    add_council_basemaps(m_orig, selection = 7), # Number too high
    "Invalid 'selection'. Choose numbers between 1 and 6."
  )
  # Test with a mix of valid and invalid numbers.
  expect_error(
    add_council_basemaps(m_orig, selection = c(1, 99, 2)),
    "Invalid 'selection'. Choose numbers between 1 and 6."
  )
  # Test with NA_real_ in the selection.
  expect_error(
    add_council_basemaps(m_orig, selection = c(1, NA_real_)),
    "Invalid 'selection'. Choose numbers between 1 and 6."
  )
  # Test with NA (generic NA, treated as logical by default) in the selection.
  expect_error(
    add_council_basemaps(m_orig, selection = c(1, NA, 2)),
    "Invalid 'selection'. Choose numbers between 1 and 6."
  )
}) # End of "empty or invalid numeric selections" test_that block


# --- Test Block 8: Testing if the order of custom_names matches the order of selection ---
test_that("custom_names order matches selection order", {
  # Standard setup.
  skip_if_not_installed("leaflet")
  library(leaflet)

  # --- Setup ---
  m_orig <- leaflet()
  # Define a selection where the order matters for custom names: Satellite (5) then Light (1).
  selection <- c(5, 1)
  # Define custom names corresponding to this order.
  custom <- c("My Satellite", "My Light")
  # Call the function.
  m <- add_council_basemaps(m_orig, selection = selection, custom_names = custom)

  # --- Retrieve results ---
  provider_calls <- get_leaflet_calls(m, "addProviderTiles")
  control_calls <- get_leaflet_calls(m, "addLayersControl")

  # --- Assertions for Provider Tiles order ---
  # expect_length: Ensure 2 provider tiles were added.
  expect_length(provider_calls, 2)
  # expect_equal: Check that the first provider tile corresponds to ID 5 and the first custom name.
  expect_equal(provider_calls[[1]]$args[[1]], get_provider_url(5))
  expect_equal(provider_calls[[1]]$args[[3]], custom[1]) # Group name should be custom[1]
  # expect_equal: Check that the second provider tile corresponds to ID 1 and the second custom name.
  expect_equal(provider_calls[[2]]$args[[1]], get_provider_url(1))
  expect_equal(provider_calls[[2]]$args[[3]], custom[2]) # Group name should be custom[2]

  # --- Assertions for Layers Control order ---
  # expect_length: Ensure addLayersControl was called once.
  expect_length(control_calls, 1)
  # Extract arguments from the addLayersControl call.
  control_args <- control_calls[[1]]$args
  # expect_equal: Check that the 'baseGroups' in the control are the custom names, in the specified order.
  expect_equal(control_args[[1]], custom)
}) # End of "custom_names order" test_that block
