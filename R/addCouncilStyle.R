#' Style a leaflet map
#'
#' @param map A \code{leaflet} map
#' @param add_dists Boolean. Add council districts?
#'
#' @return A \code{leaflet} map that in has City Council styles, including tiles,
#'    council district outlines, and fonts
#' @export
#'
#' @examples
#' library(leaflet)
#' leaflet() %>%
#'   addCouncilStyle()
#'
addCouncilStyle <- function(map, add_dists = TRUE) {

  map <- map %>%
    leaflet::addTiles(urlTemplate = "//cartodb-basemaps-{s}.global.ssl.fastly.net/light_nolabels/{z}/{x}/{y}.png",
                      options = tileOptions(maxZoom = 12)) %>%
    leaflet::addTiles(urlTemplate = "//cartodb-basemaps-{s}.global.ssl.fastly.net/light_all/{z}/{x}/{y}.png",
                      options = tileOptions(minZoom = 13, maxZoom = 17)) %>%
    htmlwidgets::prependContent(htmltools::tags$style("@import url('https://fonts.googleapis.com/css?family=Open+Sans:400,700'); .leaflet-control {font-family: 'Open Sans', sans-serif;}"))

  if(add_dists) {
    map <- map %>%
      leaflet::addPolygons(data = dists, fill = FALSE, weight = 1, color = "#2F56A6", opacity = .5) %>%
      leaflet::addLabelOnlyMarkers(data = dists, lat = ~lab_y, lng = ~lab_x, label = ~coun_dist,
                                   labelOptions = leaflet::labelOptions(permanent = TRUE, noHide = TRUE,
                                                                        textOnly = TRUE,
                                                                        textsize = 12,
                                                                        direction = "center",
                                                                        style = list(color = "#23417D",
                                                                                     `font-family` = "'Open Sans', sans-serif",
                                                                                     `font-weight` = "bold")))
  }

  return(map)
}
