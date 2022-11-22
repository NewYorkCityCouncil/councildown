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
#'  theme_nycc(facet=TRUE) +
#'  scale_color_nycc()
#' }
#' @import ggplot2
#'
theme_nycc <- function(..., print = FALSE, facet = FALSE) {

  if (print) {
    font_out <- function(...) element_text(..., family = "Times New Roman")
  } else {
    font_out <- function(...) element_text(..., family = "Georgia")

  }



  # placeholder
  if (print) {
    base_theme <- theme_classic( ...)
  } else {
    base_theme <- theme_classic( ...)
  }


  if (facet) {
    base_theme +
      theme(
        legend.position="right",
        legend.text = font_out(size = 9),
        legend.title = font_out(hjust = .5),
        strip.background = element_rect(fill = NA, color = NA),
        strip.text = font_out(size = rel(1)),
        panel.border = element_rect(fill = NA, color = "#666666", size = .5),
        panel.grid.minor.x = element_blank(),
        panel.grid.major.x = element_blank(),
        panel.grid.minor.y = element_blank(),
        panel.grid.major.y = element_blank(),
        axis.line.x.bottom=element_line(color = "#CACACA"),
        axis.line.y.left=element_line(color = "#CACACA"),
        #text = element_text(family = "Open Sans"),
        plot.title = font_out(size = 16),
        plot.subtitle = font_out(size = 12),
        axis.title.y = font_out(size = 12, margin = margin(t = 0, r = 10, b = 0, l = 0)),
        axis.ticks = element_blank(),
        axis.text.y = font_out(size = 11, margin = margin(t = 10, r = 0, b = 0, l = 0)),
        axis.text.x = font_out(size = 11),
        axis.title.x = font_out(size = 12, margin = margin(t = 10, r = 0, b = 0, l = 0))
        )
  } else {
    base_theme +
      theme(
        legend.position="right",
        legend.text = font_out(size = 9),
        legend.title = font_out(hjust = .5),
        strip.background = element_rect(fill = NA, color = NA),
        strip.text = font_out(size = rel(1)),
        panel.grid.minor.x = element_blank(),
        panel.grid.major.x = element_blank(),
        panel.grid.minor.y = element_blank(),
        panel.grid.major.y = element_blank(),
        axis.line.x.bottom=element_line(color = "#CACACA"),
        axis.line.y.left=element_line(color = "#CACACA"),
        #text = element_text(family = "Open Sans"),
        plot.title = font_out(size = 16),
        plot.subtitle = font_out(size = 12),
        axis.title.y = font_out(size = 12, margin = margin(t = 0, r = 10, b = 0, l = 0)),
        axis.ticks = element_blank(),
        axis.text.y = font_out(size = 11, margin = margin(t = 10, r = 0, b = 0, l = 0)),
        axis.text.x = font_out(size = 11),
        axis.title.x = font_out(size = 12, margin = margin(t = 10, r = 0, b = 0, l = 0))
      )
  }


}
