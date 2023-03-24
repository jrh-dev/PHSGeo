#' Perform a clean install of geospatial package dependencies
#' 
#' @description Recursively detects geospatial package dependencies and removes
#'  them before performing a fresh installation
#'  
#' @param geo_pkgs specify the geospatial packages for which dependencies will
#'  be detected and removed
#'  
#' @param binary_repo url to specify a repo for package binaries
#' 
#' @return invisible, function is called for its side-effects
#' 
#' @export
clean_install = function(
    geo_pkgs = c("leaflet", "rgdal", "raster", "sp", "terra", "sf"),
    binary_repo = "https://ppm.publichealthscotland.org/all-r/__linux__/centos7/latest"
    ) {
  
  installed_pkgs = as.data.frame(installed.packages())
  
  # note base packages
  base_pkgs = installed_pkgs$Package[
    !is.na(installed_pkgs$Priority) & installed_pkgs$Priority %in% c("base", "recommended")]
  
  # get geospatial package dependencies
  geo_deps_installed = geo_deps = unique(unlist(tools::package_dependencies(
    packages = geo_pkgs, recursive = TRUE)))
  
  geo_deps_installed = c(geo_deps, "parallelly")
  
  # remove any dependencies which are NOT currently installed
  geo_deps_installed = geo_deps_installed[
    !geo_deps_installed %in% base_pkgs & 
      geo_deps_installed %in% installed_pkgs$Package]
  
  # TODO also dont remove this packages deps duh
  
  message(glue::glue("Removing dependencies of:"))
  
  for (pkg in geo_pkgs) message(paste(pkg))
  
  if (length(geo_deps_installed) > 0) {
    for (pkg in geo_deps_installed) {
      eval(parse(text=glue::glue("detach(package:{pkgs},unload=TRUE)")))
      message(glue::glue("Removing {pkg}"))
      remove.packages(pkg)
    }
  }
  
  # start clean install
  install.packages("parallelly")
  
  # Identify number of CPUs available
  ncpus = as.numeric(parallelly::availableCores())
  
  # Get list of geospatial package dependencies that can be installed as binaries
  geo_deps_bin = sort(setdiff(geo_deps, geo_pkgs))
  
  # Install these as binaries
  for (pkg in geo_deps_bin) {
    eval(parse(text=glue::glue("detach(package:{pkg},unload=TRUE)")))
    message(glue::glue("Installing {pkg}"))
    install.packages(pkg, repos = binary_repo, Ncpus = ncpus)
  }
  
  return(invisible())
}

