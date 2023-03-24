
#' Install a geospatial package
#' 
#' @desciption Install one of the following geospatial packages;
#'  * sf
#'  * terra
#'  * sp
#'  * raster
#'  * rgdal
#'  * leaflet
#'  
#' @param package string specifying the name of the package to install
#' @param repo string specifying a repository
#' 
#' @return invisible, this function is called for its side effects
geo_install = function(package, repo, geo_config_args = NULL) {
  
  if (!exists(".PHSGeo_env")) {
    stop("Please run 'PHSGeo::setup_env()' before attempting to install packages")
  }
  
  class(package) = package
  
  UseMethod("geo_install", package)
  
}

geo_install.sf = function(package, repo = "https://ppm.publichealthscotland.org/all-r/latest") {
  
  ncpus = as.numeric(parallelly::availableCores())
  
  install.packages("sf", configure.args = ._get_config(),
                   INSTALL_opts = "--no-test-load", repos = repo,
                   Ncpus = ncpus)
  
  return(invisible())
}

geo_install.terra = function(package, repo = "https://ppm.publichealthscotland.org/all-r/latest") {
  
  ncpus = as.numeric(parallelly::availableCores())
  
  install.packages("terra", configure.args = ._get_config(),
                   INSTALL_opts = "--no-test-load", repos = repo,
                   Ncpus = ncpus)
  
  return(invisible())
}


geo_install.sp = function(package, repo = "https://ppm.publichealthscotland.org/all-r/latest") {
  
  ncpus = as.numeric(parallelly::availableCores())
  
  install.packages("sp", configure.args = ._get_config(),
                   INSTALL_opts = "--no-test-load", repos = repo,
                   Ncpus = ncpus)
  
  return(invisible())
}


geo_install.raster = function(package, repo = NULL) {
  
  ncpus = as.numeric(parallelly::availableCores())
  
  install.packages("https://ppm.publichealthscotland.org/all-r/latest/src/contrib/Archive/raster/raster_2.5-8.tar.gz",
                   type = "source",
                   configure.args = ._get_config(),
                   INSTALL_opts = "--no-test-load", 
                   repos = repo,
                   Ncpus = ncpus)
  
  return(invisible())
}


geo_install.rgdal = function(package, repo = NULL) {
  
  ncpus = as.numeric(parallelly::availableCores())
  
  install.packages("https://ppm.publichealthscotland.org/all-r/latest/src/contrib/Archive/rgdal/rgdal_1.5-25.tar.gz",
                   type = "source",
                   configure.args = ._get_config(),
                   INSTALL_opts = "--no-test-load", 
                   repos = repo,
                   Ncpus = ncpus)
  
  return(invisible())
}


geo_install.leaflet = function(package, repo = "https://ppm.publichealthscotland.org/all-r/__linux__/centos7/latest") {
  
  ncpus = as.numeric(parallelly::availableCores())
  
  install.packages("leaflet", repos = repo, Ncpus = ncpus)
  
  return(invisible())
}


._get_config = function(...) {
  
  paths = .PHSGeo_env$geo_deps
  
  config = c(
    glue::glue("--with-gdal-config={paths$gdal['gdal_config_path']}"),
    glue::glue("--with-proj-include={paths$proj['proj_config_path_2']}"),
    glue::glue("--with-proj-lib={paths$proj['proj_config_path_1']}"),
    glue::glue("--with-geos-config={paths$geos['proj_config_path']}")
    )
  
  return(config)
}