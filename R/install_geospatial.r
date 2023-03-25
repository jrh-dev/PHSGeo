#' Install geospatial packages
#' 
#' @description Meta function to facilitate the full process of installing a 
#'  geospatial package; including dependency discovery and confirmation, 
#'  environment setup, and installation. Additionally can perform clean 
#'  intallation of all geospatial package dependencies.
#'  
#' @param pkgs string vector specifying packages to install
#' @param clean logical whether a clean install is required
#' 
#' @return invisible, this function is called for its side effects
#' @export
install_geospatial = function(pkgs = c("leaflet", "rgdal", "raster", "sp", "terra", "sf"),
                              clean = FALSE) {
  
  if (!all(pkgs %in% c("leaflet", "rgdal", "raster", "sp", "terra", "sf"))) {
    stop("'PHSGeo::install_packages' only works with 'leaflet', 'rgdal', 'raster', 'sp', 'terra', 'sf'")
  }
  
  message("Setting up environment")
  setup_env()
  message("Environment setup complete")
  
  if (clean) {
    
    confirm_txt = glue::glue(
      "CAUTION - Performing a clean installation of all geospatial package ",
      "dependencies typically involves the removal and installation of a large ",
      "number of packages. It is highly recommended that users first attempt ",
      "installation without performing this step. \n\n",
      "Are you sure that you wish to proceed with a clean installation?"
    )
    
    confirm_cont = utils::menu(c("Yes", "No"), title=confirm_txt)
    
    if (confirm_cont == 1) {
      message("Starting clean installation of geospatial dependencies")
      clean_install()
      message("Clean installation of geospatial dependencies complete")
    } else {
      
    }
  }
  
  for (pkg in pkgs) {
    message(glue::glue("Attempting installation of {pkg}"))
    geo_install(pkg)
  }
  
  return(invisible())
}

