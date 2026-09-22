# R (councildown)

Load councildown after ggplot2 is fine; councildown replaces ggplot's default
color and fill scales with Council ones.

## ggplot

```r
library(ggplot2)
library(councildown)

ggplot(df, aes(borough, n, fill = type)) +
  geom_col() +
  scale_fill_nycc("main") +       # categorical, max 7 levels
  theme_nycc() +                  # Georgia, no gridlines/ticks, grey axis lines
  labs(title = "...", caption = "Source: ...")
```

- `theme_nycc(print = TRUE)` for printed output (Times New Roman);
  `theme_nycc(facet = TRUE)` for small multiples.
- `scale_fill_nycc(palette, discrete = FALSE)` / `scale_color_nycc(...)` for continuous.
- `pal_nycc("warm")` returns raw colors; `pal_nycc("single")` / `"double"` for 1–2 series.
- Don't use `scale_*_manual()` with hand-typed hex, or viridis/brewer palettes.

## leaflet

```r
leaflet(tracts) %>%
  addCouncilStyle(add_dists = TRUE, dist_year = "2023") %>%
  add_council_basemaps() %>%
  addPolygons(fillColor = ~pal(rate), fillOpacity = 1) %>%   # councildown's addPolygons: weight 0
  addLegend_decreasing(pal = pal, values = ~rate, decreasing = TRUE) %>%
  addSourceText("Source: ...")
```

- `pal <- colorBin("nycc_blue", domain = tracts$rate)`: max 7 bins, NA white.
- `colorDiverging(values, mid = "median")` for above/below-midpoint data.
- `councilPopup(html)` for popups; `set_council_mapsize(map, "full_screen")` for layout;
  `mapshot()` to save images.

## R Markdown

Use `councildown::council_html` or `councildown::council_pdf` as the output format.
