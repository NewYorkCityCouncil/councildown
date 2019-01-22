#' New York City Council Theme
#'
#' This is a \code{ggplot2} theme that uses Council fonts and style guidelines
#' to produce plots.
#'
#' @param ... Further arguments passed to \code{theme_bw()}.
#' @param print Boolean. Changes fonts to Times New Roman to match printed
#'     documents produced by committees.
#'
#' @export
#'
#' @examples
#' \dontrun{
#' library(ggplot2)
#' library(councildown)
#' data.frame(x = rnorm(20), y = rnorm(20), z = c("a", "b")) %>%
#'   ggplot(aes(x, y, color = z)) +
#'  geom_point() +
#'  labs(title = "Test",
#'       subtitle = "Test",
#'       caption = "Test",
#'       color = "Legend",
#'       x = "Test a",
#'       y = "Test b") +
#'  facet_wrap(~z) +
#'  theme_nycc() +
#'  scale_color_nycc()
#' }
#' @import ggplot2
#'
theme_nycc <- function(..., print = FALSE) {

  if (print) {
    font_out <- function(...) element_text(..., family = "Times New Roman")
  } else {
    font_out <- function(...) element_text(..., family = "Georgia")

  }

  if (print) {
    base_theme <- theme_bw(base_family = "Times New Roman", ...)
  } else {
    base_theme <- theme_bw(base_family = "Open Sans", ...)

  }
  base_theme +
    theme(
          legend.title = font_out(hjust = .5),
          plot.title = font_out(),
          plot.subtitle = font_out(color = "#666666"),
          plot.caption = element_text(hjust = 0, color = "#666666"),
          strip.background = element_rect(fill = NA, color = NA),
          panel.border = element_rect(fill = NA, color = "#666666", size = .5),
          # panel.background = element_rect(fill = NA, color = "#666666", size = .5),
          axis.title = font_out(),
          axis.line = element_line(color = NA),
          axis.ticks = element_line(color = "#666666", size = .5),
          panel.grid.major = element_line(color = "#CACACA", size = .2),
          panel.grid.minor = element_line(color = "#CACACA", size = .1),
          complete = TRUE)
}
