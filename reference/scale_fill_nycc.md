# Color and fill scales for ggplots

The functions `scale_*_continuous` and `scale_*_discrete` are exported
from this package as aliases for the functions `scale_*_nycc` with
appropriate default arguments. Because of this, these colors will
overwrite `ggplot2`'s default scales. To prevent this, either set scales
manually in plots by calling `ggplot2::scale_*`, or attach `ggplot2`
after `councildown`.

## Usage

``` r
scale_fill_nycc(palette = "mixed", discrete = TRUE, reverse = FALSE, ...)

scale_color_nycc(palette = "main", discrete = TRUE, reverse = FALSE, ...)

scale_color_discrete(palette = "main", discrete = TRUE, reverse = FALSE, ...)

scale_color_continuous(...)

scale_fill_discrete(palette = "mixed", discrete = TRUE, reverse = FALSE, ...)

scale_fill_continuous(...)
```

## Arguments

- palette:

  One of
  `"bw","main", "mixed", "nycc_blue", "cool", "warm", "diverging", "indigo", "blue", "violet", "bronze", "orange", "forest", "single", "double"`.
  When palette is set to "single" or "double", it returns the first
  color and first and second color from the "main" palette respectively.

- discrete:

  Boolean, should the scale be discrete?

- reverse:

  Boolean, reverse the order of the selected palette

- ...:

  Further arguments passed to `scale_*` from `ggplot2`

## Details

When `discrete` is `TRUE` arguments are passed via `...` to
[`discrete_scale`](https://ggplot2.tidyverse.org/reference/discrete_scale.html).
This is the default behavior. Otherwise, `...` arguments are passed to
[`scale_color_gradientn`](https://ggplot2.tidyverse.org/reference/scale_gradient.html)
or
[`scale_fill_gradientn`](https://ggplot2.tidyverse.org/reference/scale_gradient.html)
as appropriate.
