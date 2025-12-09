# Add a "Source" note to a leaflet that will be a static output

Add a "Source" note to a leaflet that will be a static output

## Usage

``` r
addSourceText(
  map,
  source_text,
  color = "#555555",
  fontSize = "15px",
  lat = -73.645,
  lon = 40.5,
  ...
)
```

## Arguments

- map:

  A `leaflet` map

- source_text:

  The text that you want added to the map

- color:

  color of source text

- fontSize:

  font size of source text

- lat:

  the latitude of the source text on the map

- lon:

  the longitude of the source text on the map

## Value

A `leaflet` map with a source note added in the bottom right for the
councildown defined NYC frame
