#' Style a leaflet map
#'
#' @param map A \code{leaflet} map
#'
#' @return A \code{leaflet} map that in has City Council styles, including tiles,
#'    council district outlines, and fonts
#' @export
#'
#' @examples
#' library(leaflet)
#' leaflet() %>%
#'   addCouncilStyle
#'
addCouncilStyle <- function(map) {

  map %>%
    leaflet::addTiles(urlTemplate = "//cartodb-basemaps-{s}.global.ssl.fastly.net/light_nolabels/{z}/{x}/{y}.png") %>%
    leaflet::addPolygons(data = dists, fill = FALSE, weight = .5, color = "black", opacity = .2) %>%
    leaflet::addLabelOnlyMarkers(data = dists, lat = ~lab_y, lng = ~lab_x, label = ~coun_dist,
                        labelOptions = leaflet::labelOptions(permanent = TRUE, noHide = TRUE,
                                                    textOnly = TRUE,
                                                    textsize = "13px",
                                                    direction = "center",
                                                    style = list(color = "#0004",
                                                                 `font-family` = "'Open Sans', sans-serif",
                                                                 `font-weight` = "bold"))) %>%
    htmlwidgets::prependContent(htmltools::tags$style("@import url('https://fonts.googleapis.com/css?family=Open+Sans'); .leaflet-control {font-family: 'Open Sans', sans-serif;}"))
}
