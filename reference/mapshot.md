# mapshot pdf

This is a `mapshot` adjustment that saves maps as pdf and warns users if
they choose png

## Usage

``` r
mapshot(
  x,
  url = NULL,
  file = NULL,
  zoom = 2,
  vwidth = 1000,
  vheight = 850,
  remove_controls = c("zoomControl", "layersControl", "homeButton", "scaleBar",
    "drawToolbar", "easyButton"),
  ...
)
```

## Arguments

- x:

  `mapview` or `leaflet` object (or any other hmtlwidget).

- url:

  Output `.html` file. If not supplied and 'file' is specified, a
  temporary index file will be created.

- file:

  Output `.png`, `.pdf`, or `.jpeg` file.

- remove_controls:

  `character` vector of control buttons to be removed from the map when
  saving to file. Any combination of "zoomControl", "layersControl",
  "homeButton", "scaleBar", "drawToolbar", "easyButton". If set to
  `NULL` nothing will be removed. Ignord if `x` is not a mapview or
  leaflet map.

- ...:

  Further arguments passed on to
  [`saveWidget`](https://rdrr.io/pkg/htmlwidgets/man/saveWidget.html)
  and/or `webshot`.

## Examples

``` r
if (FALSE) { # \dontrun{
library(leaflet)
library(councildown)
m <- leaflet() %>%
 addTiles() %>%
 addCouncilStyle(add_dists = TRUE)
mapshot(m, file = "test.png")
file.remove("test.png")
} # }
```
