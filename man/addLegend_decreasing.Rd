% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/mapshot.R
\name{addLegend_decreasing}
\alias{addLegend_decreasing}
\title{addLegend - but with the option for the highest number to be at the top of the legend}
\usage{
addLegend_decreasing(
  map,
  position = c("topright", "bottomright", "bottomleft", "topleft"),
  pal,
  values,
  na.label = "NA",
  bins = 7,
  colors,
  opacity = 0.5,
  labels = NULL,
  labFormat = labelFormat(),
  title = NULL,
  className = "info legend",
  layerId = NULL,
  group = NULL,
  data = getMapData(map),
  decreasing = FALSE
)
}
\description{
solution from mpriem89 (https://github.com/rstudio/leaflet/issues/256#issuecomment-440290201)
}
