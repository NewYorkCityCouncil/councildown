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
#' library(councildown)
#' leaflet() %>%
#'  addCouncilStyle(add_dists=TRUE)
#'
addCouncilStyle <- function(map, add_dists = FALSE, minZoom = 10, maxZoom = 15) {

  map <-  map %>%
    leaflet(options = leafletOptions(minZoom = minZoom, maxZoom = maxZoom)) %>%
    setView(-73.984865,40.710542, zoom = 11) %>%
    leaflet.extras::setMapWidgetStyle(list(background= "white"))


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
