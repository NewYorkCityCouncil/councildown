# New York City Council Theme

This is a `ggplot2` theme that uses Council fonts and style guidelines
to produce plots.

## Usage

``` r
theme_nycc(..., print = FALSE, facet = FALSE)
```

## Arguments

- ...:

  Further arguments passed to
  [`theme_bw()`](https://ggplot2.tidyverse.org/reference/ggtheme.html).

- print:

  Boolean. Changes fonts to Times New Roman to match printed documents
  produced by committees.

## Examples

``` r
if (FALSE) { # \dontrun{
library(ggplot2)
library(councildown)
data.frame(x = rnorm(20), y = rnorm(20), z = c("a", "b")) %>%
  ggplot(aes(x, y, color = z)) +
 geom_point() +
 labs(title = "Test",
      subtitle = "Test",
      caption = "Test",
      color = "Legend",
      x = "Test a",
      y = "Test b") +
 facet_wrap(~z) +
 theme_nycc(facet=TRUE) +
 scale_color_nycc()
} # }
```
