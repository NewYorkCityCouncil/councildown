# Basic Styling for Leaflet Popups

This function wraps its input in a `<div>` and sets council fonts for
body and headers.

## Usage

``` r
councilPopup(x)
```

## Arguments

- x:

  The popup HTML

## Value

A character vector

## Examples

``` r
councilPopup("Test")
#> [1] "<div><style>h1,h2,h3,h4,h5 {font-family: Georgia, serif; margin: inherit;}\nfont-family: 'Open Sans', sans-serif;\noverflow-wrap: break-word; word-wrap: break-word;</style>Test</div>"
```
