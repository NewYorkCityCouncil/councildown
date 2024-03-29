% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/colors.R
\name{scale_nycc}
\alias{scale_nycc}
\title{Make a color palette with NYCC colors for scale_*_nycc}
\usage{
scale_nycc(palette = "mixed", reverse = FALSE, ...)
}
\arguments{
\item{palette}{One of \code{"bw","main", "mixed", "nycc_blue", "cool", "warm", "diverging", "indigo", "blue", "violet", "bronze", "orange", "forest", "single", "double"}. When palette is set to "single" or "double", it returns the first color and first and second color from the "main" palette respectively.}

\item{reverse}{Boolean, reverse the order of the selected palette}

\item{...}{Further arguments passed to \code{colorRampPalette}}
}
\value{
A function made by \code{colorRampPalette}
}
\description{
Make a color palette with NYCC colors for scale_*_nycc
}
