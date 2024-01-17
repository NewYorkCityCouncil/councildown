#' Style a leaflet map
#'
#' @param map A \code{leaflet} map
#' @param add_dists Boolean. Add council districts?
#' @param highlight_dists a vector including the numbers of council districts that you would like to use a non-standard color for the numeric label. Especially useful when using the "cool" palette with council districts as the label color here blends right in.
#' @param dist_year Either "2013" (for 2013-2023 lines) or "2023" (for 2023-2033 lines).
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

addCouncilStyle <- function(map, add_dists = FALSE, highlight_dists = NULL, dist_year = "2013",
                            highlight_color = "#cdd9f1", minZoom = 10, maxZoom = 15) {
  # Adds min and max Zoom
  map$x$options$minZoom = minZoom
  map$x$options$maxZoom = maxZoom
  map$x$options$zoomControl = F

  map <-  map %>%
    setView(-73.984865, 40.710542, zoom = 11) %>%
    leaflet.extras::setMapWidgetStyle(list(background = "white")) %>%
    htmlwidgets::onRender("function(el, x) {
        L.control.zoom({ position: 'topright' }).addTo(this)
    }")


  if(add_dists) {
    if(dist_year != "2013" & dist_year != "2023") {stop("The dist_year you have entered is invalid. Choose either '2013' or '2023'")}
    if(dist_year == "2013") {dists <- councildown::nycc_cd_13} else {dists <- councildown::nycc_cd_23}

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


#' Add a "Source" note to a leaflet that will be a static output
#'
#' @param map A \code{leaflet} map
#' @param source_text The text that you want added to the map
#' @param color color of source text
#' @param fontSize font size of source text
#'
#' @return A \code{leaflet} map with a source note added in the bottom right for the councildown defined NYC frame
#' @export
addSourceText <- function(map, source_text, color = "#555555", fontSize = "15px", ...) {

  geo = sf::st_sfc(sf::st_point(c(-73.645, 40.5)))
  source_notes_geo = sf::st_sf(source = source_text,
                           geometry = geo)

  map = map %>%
    leaflet::addLabelOnlyMarkers(data = source_notes_geo,
                                 label = ~source,
                                 labelOptions = labelOptions(noHide = T,
                                                             direction = 'left',
                                                             textOnly = T,
                                                             style = list('color'="#555555",
                                                                          'fontSize'="15px")))

  return(map)

}


#' Wrapper for addPolygons
#'
#' All the same inputs apply as the leaflet::addPolygons function, we just use this wrapper to define the "defaults" for certain inputs
#'
#' @param map A \code{leaflet} map
#'
#' @return A \code{leaflet} map with polygons added
#' @export
#'
addPolygons <- function(map, smoothFactor = 0, weight = 0, ...) {
  map = map %>%
    leaflet::addPolygons(smoothFactor = smoothFactor,
                         weight = weight, ...)

  return(map)
}

#' Wrapper for colorBin
#'
#' All the same inputs apply as the leaflet::colorBin function, just use this wrapper to define the "defaults" for certain inputs
#'
#' @param domain Possible values to be mapped by \code{leaflet}
#'
#' @return A \code{leaflet} colorBin palette
#' @export
#'
colorBin <- function(palette = "nycc_blue", domain = NULL,
                     bins = 7, na.color = "#FFFFFF", ...) {
  if((length(bins) == 1 & bins[1] > 7) | length(bins) > 7){
    cli::cli_abort("Can't create color mapping with more than 7 bins")
  }
  leaflet::colorBin(
    palette = ifelse(!is.null(nycc_palettes[[palette]]), councildown::pal_nycc(palette), palette),
    na.color = na.color,
    bins = bins,
    domain = domain
  )
}
