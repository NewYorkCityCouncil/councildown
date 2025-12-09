# Wrapper for colorBin

All the same inputs apply as the leaflet::colorBin function, just use
this wrapper to define the "defaults" for certain inputs

## Usage

``` r
colorBin(
  palette = "nycc_blue",
  domain = NULL,
  bins = 7,
  na.color = "#FFFFFF",
  ...
)
```

## Arguments

- domain:

  Possible values to be mapped by `leaflet`

## Value

A `leaflet` colorBin palette
