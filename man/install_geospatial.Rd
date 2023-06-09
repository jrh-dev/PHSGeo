% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/install_geospatial.r
\name{install_geospatial}
\alias{install_geospatial}
\title{Install geospatial packages}
\usage{
install_geospatial(
  pkgs = c("leaflet", "rgdal", "raster", "sp", "terra", "sf"),
  clean = FALSE
)
}
\arguments{
\item{pkgs}{string vector specifying packages to install}

\item{clean}{logical whether a clean install is required}
}
\value{
invisible, this function is called for its side effects
}
\description{
Meta function to facilitate the full process of installing a
geospatial package; including dependency discovery and confirmation,
environment setup, and installation. Additionally can perform clean
intallation of all geospatial package dependencies.
}
