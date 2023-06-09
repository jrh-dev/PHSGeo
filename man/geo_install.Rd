% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/geo_install.r
\name{geo_install}
\alias{geo_install}
\title{Method for installing a geospatial package}
\usage{
geo_install(package)
}
\arguments{
\item{package}{string specifying the name of the package to install}
}
\value{
invisible, this function is called for its side effects
}
\description{
Install one of the following geospatial packages;
\itemize{
\item sf
\item terra
\item sp
\item raster
\item rgdal
\item leaflet
}
}
