# Set Leaflet Map Size and Position

Modifies a leaflet map widget's size and position using pre-defined
layouts. This is achieved by injecting CSS to style the map's container.
It's ideal for creating standalone map pages, dashboards, or reports.

## Usage

``` r
set_council_mapsize(map, layout = "full_screen")
```

## Arguments

- map:

  A leaflet map object created by \`leaflet::leaflet()\`.

- layout:

  A character string specifying one of the pre-defined layouts. Defaults
  to \`"full_screen"\`. The available options are:

  - \`"full_screen"\`: The map fills the entire browser viewport (100

  - \`"right"\`: The map fills the right 75

  - \`"left"\`: The map fills the left 75

  - \`"top"\`: The map fills the top 75

  - \`"bottom"\`: The map fills the bottom 75

## Value

A modified leaflet map object that will render in the specified layout.
The object remains a \`leaflet\` map, so it can be piped into other
functions.

## Details

This function uses \`htmlwidgets::prependContent\` to add a
\`\<style\>\` tag to the map's HTML dependencies. The generated CSS will
vary based on the chosen \`layout\`. For directional layouts (e.g.,
\`"right"\`), the map will occupy 75 of the viewport, leaving the
remaining 25 or controls in your R Markdown or HTML document.

## Examples

``` r
if (FALSE) { # \dontrun{
if (requireNamespace("leaflet", quietly = TRUE)) {
  library(leaflet)
  library(councildown)

  # Default: Create a full-screen map
  leaflet() %>%
    set_council_mapsize() %>%
    add_council_basemaps()

  # Create a map that fills the right 75% of the screen
  # (You would add content to the left 25% in your Rmd or HTML)
  leaflet() %>%
    set_council_mapsize(layout = "right") %>%
    add_council_basemaps()
}
} # }
```
