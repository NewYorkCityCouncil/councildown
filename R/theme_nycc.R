#' Title
#'
#' @param ...
#'
#' @return
#' @export
#'
#' @examples
theme_nycc <- function(...) {

  georgia <- function(...) element_text(..., family = "Georgia")

  theme_bw(base_family = "Open Sans", ...) +
    theme(
          legend.title = georgia(hjust = .5),
          plot.title = georgia(),
          plot.subtitle = georgia(color = "#666666"),
          plot.caption = element_text(hjust = 0, color = "#666666"),
          strip.background = element_rect(fill = NA, color = NA),
          panel.border = element_rect(fill = NA, color = "#666666", size = .5),
          # panel.background = element_rect(fill = NA, color = "#666666", size = .5),
          axis.line = element_line(color = NA),
          axis.ticks = element_line(color = "#666666", size = .5),
          panel.grid.major = element_line(color = "#CACACA", size = .2),
          panel.grid.minor = element_line(color = "#CACACA", size = .1),
          complete = TRUE)
}
