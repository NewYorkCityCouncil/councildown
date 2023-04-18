#' Style a leaflet map
#'
#' @param map A \code{leaflet} map
#' @param add_dists Boolean. Add council districts?
#' @param highlight_dists a vector including the numbers of council districts that you would like to use a non-standard color for the numeric label. Especially useful when using the "cool" palette with council districts as the label color here blends right in. 
#' @param highlight_color used IF you specify a list of highlight_dists as the color for their text. Defaults to white
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
addCouncilStyle <- function(map, add_dists = FALSE, highlight_dists = NULL, 
                            highlight_color = "white") {

  map <-  map %>%
    setView(-73.984865, 40.710542, zoom = 11) %>%
    leaflet.extras::setMapWidgetStyle(list(background = "white"))


  if(add_dists) {
    map <- map %>%
      leaflet::addPolygons(data = dists, fill = FALSE, weight = 1, 
                           color = "#2F56A6", opacity = .5, smoothFactor = 0, 
                           group = "Council Districts") %>%
      leaflet::addLabelOnlyMarkers(data = dists, lat = ~lab_y, lng = ~lab_x, label = ~coun_dist,
                                   labelOptions = leaflet::labelOptions(permanent = TRUE, noHide = TRUE,
                                                                        textOnly = TRUE,
                                                                        textsize = 12,
                                                                        direction = "center",
                                                                        style = list(color = "#23417D",
                                                                                     "font-family" = "'Open Sans', sans-serif",
                                                                                     "font-weight" = "bold")))
    
    if (length(highlight_dists) > 0) {
      map <- map %>% 
        leaflet::addLabelOnlyMarkers(data = dists[dists$coun_dist %in% highlight_dists, ], 
                                     lat = ~lab_y, lng = ~lab_x, label = ~coun_dist,
                                     labelOptions = leaflet::labelOptions(permanent = TRUE, noHide = TRUE,
                                                                          textOnly = TRUE,
                                                                          textsize = 12,
                                                                          direction = "center",
                                                                          style = list(color = highlight_color,
                                                                                       "font-family" = "'Open Sans', sans-serif",
                                                                                       "font-weight" = "bold")))
    }
  }

  return(map)
}
