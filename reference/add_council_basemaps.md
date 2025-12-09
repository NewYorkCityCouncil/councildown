# Add Selectable Council Basemaps to a Leaflet Map

Adds a user-selected set of base map tile layers and a layer control to
switch between them on a leaflet map widget.

## Usage

``` r
add_council_basemaps(
  map,
  selection = NULL,
  custom_names = NULL,
  control_position = "bottomleft",
  control_collapsed = TRUE
)
```

## Arguments

- map:

  A leaflet map object created by
  [`leaflet::leaflet()`](https://rstudio.github.io/leaflet/reference/leaflet.html).

- selection:

  A numeric vector specifying which basemaps to add. Defaults to
  \`NULL\`, which adds all available basemaps (1 through 6). The
  available basemaps are:

  - 1: Light (CartoDB.Positron)

  - 2: Dark (CartoDB.DarkMatter)

  - 3: Streets (CartoDB.Voyager)

  - 4: Physical (Esri.WorldTopoMap)

  - 5: Satellite (Esri.WorldImagery)

  - 6: Basic (Esri.WorldGrayCanvas)

  Example: \`selection = c(1, 5)\` to add Light and Satellite maps.

- custom_names:

  An optional character vector to provide custom names for the selected
  basemaps in the layer control. The length of \`custom_names\` must
  match the number of unique, valid basemaps in \`selection\`. The order
  of names in \`custom_names\` will correspond to the order of basemaps
  specified in \`selection\`. If \`NULL\` (default), default names
  ("Light", "Dark", etc.) are used.

- control_position:

  The position of the layers control toggle. Defaults to "bottomleft".
  Other options include "topright", "bottomright", "topleft".

- control_collapsed:

  Logical; should the layers control be collapsed initially? Defaults to
  TRUE.

## Value

The modified leaflet map object with selected basemaps and layer control
added.

## Examples

``` r
if (FALSE) { # \dontrun{
if (requireNamespace("leaflet", quietly = TRUE)) {
  library(leaflet)

  # Add all default basemaps
  leaflet() %>%
    setView(lng = -74.0060, lat = 40.7128, zoom = 10) %>%
    add_council_basemaps()

  # Add only Light (1) and Satellite (5) basemaps with default names
  leaflet() %>%
    setView(lng = -74.0060, lat = 40.7128, zoom = 10) %>%
    add_council_basemaps(selection = c(1, 5))

  # Add Dark (2), Streets (3), and Physical (4) with custom names
  leaflet() %>%
    setView(lng = -74.0060, lat = 40.7128, zoom = 10) %>%
    add_council_basemaps(selection = c(2, 3, 4),
                         custom_names = c("Dark Theme", "Street Details", "Terrain View"),
                         control_position = "topright")

  # Add Satellite (5) first, then Light (1), control collapsed false
   leaflet() %>%
    setView(lng = -74.0060, lat = 40.7128, zoom = 10) %>%
    add_council_basemaps(selection = c(5, 1), control_collapsed = FALSE)
}
} # }
```
