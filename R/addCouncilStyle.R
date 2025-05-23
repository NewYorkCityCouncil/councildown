#' Style a leaflet map
#'
#' @param map A \code{leaflet} map
#' @param add_dists Boolean. Add council districts?
#' @param highlight_dists a vector including the numbers of council districts that you would like to use a non-standard color for the numeric label. Especially useful when using the "cool" palette with council districts as the label color here blends right in.
#' @param dist_year Either "2013" (for 2013-2023 lines) or "2023" (for 2023-2033 lines).
#' @param highlight_color used IF you specify a list of highlight_dists as the color for their text. Defaults to white
#' @param minZoom Minimum zoom level for the map. Defaults to 10.
#' @param maxZoom Maximum zoom level for the map. Defaults to 15.
#'
#' @return A \code{leaflet} map that in has City Council styles, including tiles,
#'    council district outlines, and fonts
#'
#' @examples
#' library(leaflet)
#' library(councildown)
#' leaflet() %>%
#'  addCouncilStyle(add_dists=TRUE)
#'
#' @export
addCouncilStyle <- function(map,
                            add_dists = FALSE,
                            highlight_dists = NULL,
                            dist_year = "2013",
                            highlight_color = "#cdd9f1",
                            minZoom = 10, maxZoom = 15)
{
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
    if(dist_year != "2013" & dist_year != "2023")
    {stop("The dist_year you have entered is invalid. Choose either '2013' or '2023'")}
    if(dist_year == "2013") {dists <- councildown::nycc_cd_13}
    else {dists <- councildown::nycc_cd_23}

    map <- map %>%
      leaflet::addPolygons(data = dists,
                           fill = FALSE,
                           weight = 1,
                           color = "#2F56A6",
                           opacity = .5,
                           smoothFactor = 0,
                           group = "Council Districts") %>%
      leaflet::addLabelOnlyMarkers(data = dists,
                                   lat = ~lab_y, lng = ~lab_x,
                                   label = ~coun_dist,
                                   labelOptions =
                                     leaflet::labelOptions(permanent = TRUE,
                                                           noHide = TRUE,
                                                           textOnly = TRUE,
                                                           textsize = 12,
                                                           direction = "center",
                                                           style =
                                                             list(color =  "#23417D", "font-family" = "'Open Sans', sans-serif", "font-weight" = "bold")))

    if (length(highlight_dists) > 0) {

      map <- map %>%
        leaflet::addLabelOnlyMarkers(data = dists[dists$coun_dist %in% highlight_dists, ],
                                     lat = ~lab_y, lng = ~lab_x, label = ~coun_dist,
                                     labelOptions = leaflet::labelOptions
                                     (permanent = TRUE, noHide = TRUE,
                                       textOnly = TRUE, textsize = 12,
                                       direction = "center",
                                       style = list(color = highlight_color,
                                                    "font-family" = "'Open Sans',
                                      sans-serif", "font-weight" = "bold")))
    }
  }

  return(map)
}
#'
#'
#' Add a "Source" note to a leaflet that will be a static output
#'
#' @param map A \code{leaflet} map
#' @param source_text The text that you want added to the map
#' @param color color of source text
#' @param fontSize font size of source text
#' @param lat the latitude of the source text on the map
#' @param lon the longitude of the source text on the map
#'
#' @return A \code{leaflet} map with a source note added in the bottom right for the councildown defined NYC frame
#'
#' @export
addSourceText <- function(map, source_text, color = "#555555",
                          fontSize = "15px", lat=-73.645, lon=40.5,...) {

  geo = sf::st_sfc(sf::st_point(c(lat, lon)))
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
#'
#'
#' Wrapper for addPolygons
#'
#' All the same inputs apply as the leaflet::addPolygons function, we just use this wrapper to define the "defaults" for certain inputs
#'
#' @param map A \code{leaflet} map
#'
#' @return A \code{leaflet} map with polygons added
#'
#' @export
addPolygons <- function(map, smoothFactor = 0, weight = 0, ...) {
  map = map %>%
    leaflet::addPolygons(smoothFactor = smoothFactor,
                         weight = weight, ...)

  return(map)
}
#'
#' Wrapper for colorBin
#'
#' All the same inputs apply as the leaflet::colorBin function, just use this wrapper to define the "defaults" for certain inputs
#'
#' @param domain Possible values to be mapped by \code{leaflet}
#'
#' @return A \code{leaflet} colorBin palette
#'
#' @export
colorBin <- function(palette = "nycc_blue", domain = NULL,
                     bins = 7, na.color = "#FFFFFF", ...) {
  if((length(bins) == 1 & bins[1] > 7) | length(bins) > 7){
    cli::cli_abort("Can't create color mapping with more than 7 bins")
  }
  palette <- if(!is.null(councildown::pal_nycc(palette))) {councildown::pal_nycc(palette)} else {palette}
  leaflet::colorBin(
    palette = palette,
    na.color = na.color,
    bins = bins,
    domain = domain
  )
}
#'
#' Add Selectable Council Basemaps to a Leaflet Map
#'
#' Adds a user-selected set of base map tile layers and a layer control
#' to switch between them on a leaflet map widget.
#'
#' @param map A leaflet map object created by \code{leaflet::leaflet()}.
#' @param selection A numeric vector specifying which basemaps to add.
#'   Defaults to `NULL`, which adds all available basemaps (1 through 6).
#'   The available basemaps are:
#'   \itemize{
#'     \item 1: Light (CartoDB.Positron)
#'     \item 2: Dark (CartoDB.DarkMatter)
#'     \item 3: Streets (CartoDB.Voyager)
#'     \item 4: Physical (Esri.WorldTopoMap)
#'     \item 5: Satellite (Esri.WorldImagery)
#'     \item 6: Basic (Esri.WorldGrayCanvas)
#'   }
#'   Example: `selection = c(1, 5)` to add Light and Satellite maps.
#' @param custom_names An optional character vector to provide custom names for the
#'   selected basemaps in the layer control. The length of `custom_names`
#'   must match the number of unique, valid basemaps in `selection`.
#'   The order of names in `custom_names` will correspond to the order of
#'   basemaps specified in `selection`. If `NULL` (default), default names
#'   ("Light", "Dark", etc.) are used.
#' @param control_position The position of the layers control toggle.
#'   Defaults to "bottomleft". Other options include "topright", "bottomright",
#'   "topleft".
#' @param control_collapsed Logical; should the layers control be collapsed
#'   initially? Defaults to TRUE.
#'
#' @return The modified leaflet map object with selected basemaps and layer control added.
#'
#' @export
#' @import leaflet
#'
#' @examples
#' \dontrun{
#' if (requireNamespace("leaflet", quietly = TRUE)) {
#'   library(leaflet)
#'
#'   # Add all default basemaps
#'   leaflet() %>%
#'     setView(lng = -74.0060, lat = 40.7128, zoom = 10) %>%
#'     add_council_basemaps()
#'
#'   # Add only Light (1) and Satellite (5) basemaps with default names
#'   leaflet() %>%
#'     setView(lng = -74.0060, lat = 40.7128, zoom = 10) %>%
#'     add_council_basemaps(selection = c(1, 5))
#'
#'   # Add Dark (2), Streets (3), and Physical (4) with custom names
#'   leaflet() %>%
#'     setView(lng = -74.0060, lat = 40.7128, zoom = 10) %>%
#'     add_council_basemaps(selection = c(2, 3, 4),
#'                          custom_names = c("Dark Theme", "Street Details", "Terrain View"),
#'                          control_position = "topright")
#'
#'   # Add Satellite (5) first, then Light (1), control collapsed false
#'    leaflet() %>%
#'     setView(lng = -74.0060, lat = 40.7128, zoom = 10) %>%
#'     add_council_basemaps(selection = c(5, 1), control_collapsed = FALSE)
#' }
#' }
add_council_basemaps <- function(map,
                                 selection = NULL,
                                 custom_names = NULL,
                                 control_position = "bottomleft",
                                 control_collapsed = TRUE) {

  # --- Define available basemaps ---
  .council_basemap_catalog <- list(
    `1` = list(default_name = "Light", provider_call = quote(leaflet::providers$CartoDB.Positron)),
    `2` = list(default_name = "Dark", provider_call = quote(leaflet::providers$CartoDB.DarkMatter)),
    `3` = list(default_name = "Streets", provider_call = quote(leaflet::providers$CartoDB.Voyager)),
    `4` = list(default_name = "Physical", provider_call = quote(leaflet::providers$Esri.WorldTopoMap)),
    `5` = list(default_name = "Satellite", provider_call = quote(leaflet::providers$Esri.WorldImagery)),
    `6` = list(default_name = "Basic", provider_call = quote(leaflet::providers$Esri.WorldGrayCanvas))
  )
  max_selection <- length(.council_basemap_catalog)

  # --- Input Validation ---
  if (!inherits(map, "leaflet")) {
    stop("Input 'map' must be a leaflet map object created by leaflet::leaflet().", call. = FALSE)
  }
  if (!is.character(control_position) || length(control_position) != 1) {
    stop("'control_position' must be a single character string.", call. = FALSE)
  }
  if (!is.logical(control_collapsed) || length(control_collapsed) != 1 || is.na(control_collapsed)) {
    stop("'control_collapsed' must be a single logical value (TRUE or FALSE), not NA.", call. = FALSE)
  }

  # Validate and process 'selection'
  if (is.null(selection)) {
    current_selection <- 1:max_selection # Default to all
  } else {
    if (!is.numeric(selection)) {
      stop("'selection' must be a numeric vector.", call. = FALSE)
    }
    # Keep original order, remove duplicates by processing from end, then ensure uniqueness
    selection_cleaned <- rev(unique(rev(as.integer(selection))))

    if (any(selection_cleaned < 1 | selection_cleaned > max_selection | is.na(selection_cleaned))) {
      stop(paste0("Invalid 'selection'. Choose numbers between 1 and ", max_selection, "."), call. = FALSE)
    }
    if (length(selection_cleaned) == 0 && length(selection) > 0) { # User provided non-empty but all invalid
      warning("All values in 'selection' were invalid. No basemaps added.", call. = FALSE)
      return(map)
    }
    current_selection <- selection_cleaned
  }

  if (length(current_selection) == 0) { # No basemaps to add
    return(map)
  }

  # Determine group names for controls
  group_names_for_control <- character(length(current_selection))
  if (!is.null(custom_names)) {
    if (!is.character(custom_names) || length(custom_names) != length(current_selection)) {
      stop(paste0("'custom_names' must be a character vector with ", length(current_selection),
                  " elements, matching the number of unique valid basemaps in 'selection' (order matters)."), call. = FALSE)
    }
    group_names_for_control <- custom_names
  } else {
    for (i in seq_along(current_selection)) {
      selected_id_str <- as.character(current_selection[i])
      group_names_for_control[i] <- .council_basemap_catalog[[selected_id_str]]$default_name
    }
  }

  # --- Add Selected Provider Tiles ---
  for (i in seq_along(current_selection)) {
    selected_id_str <- as.character(current_selection[i])
    tile_info <- .council_basemap_catalog[[selected_id_str]]
    current_group_name <- group_names_for_control[i]

    map <- map %>%
      leaflet::addProviderTiles(eval(tile_info$provider_call), group = current_group_name)
  }

  # --- Add Layers Control ---
  # Only add control if there are base groups to control
  if (length(group_names_for_control) > 0) {
    map <- map %>%
      leaflet::addLayersControl(
        baseGroups = group_names_for_control,
        options = leaflet::layersControlOptions(
          collapsed = control_collapsed,
          position = control_position
        )
      )
  }

  return(map)
}
