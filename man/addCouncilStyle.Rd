% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/addCouncilStyle.R
\name{addCouncilStyle}
\alias{addCouncilStyle}
\title{Style a leaflet map}
\usage{
addCouncilStyle(map, add_dists = TRUE)
}
\arguments{
\item{map}{A \code{leaflet} map}

\item{add_dists}{Boolean. Add council districts?}
}
\value{
A \code{leaflet} map that in has City Council styles, including tiles,
   council district outlines, and fonts
}
\description{
Style a leaflet map
}
\examples{
library(leaflet)
leaflet() \%>\%
  addCouncilStyle()

}
