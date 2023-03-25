#' Set LD_LIBRARY_PATH  and sets environment variables to facilitate use of 
#'  geospatial packages
#' 
#' @description Appends;
#'  
#'  * `/usr/gdal<version>/lib`
#'  
#'  * `/usr/proj<version>/lib`
#'  
#'  to the users current LD_LIBRARY_PATH value.
#'  
#'  Sets;
#'  
#'  * `GDAL_DATA = /usr/gdal<version>/share/gdal`
#'  
#'  * `PKG_CONFIG_PATH = /usr/proj<version>/lib/pkgconfig`
#'  
#'  as environment variables.
#'  
#'  Auto-detection of a working version of system dependencies is performed.
#'  
#'  @return invisible, function is called for its side-effects
#'  
#'  @export
setup_env = function() {
  
  if (.Platform$OS.type != "unix") {
    stop("Linux OS required")
  }
  
  # find linux deps installations
  gdal = ._get_gdal()
  proj = ._get_proj()
  geos = ._get_geos()
  
  # build new LD_LIBRARY_PATH
  new_path = glue::glue(
    "{Sys.getenv(\"LD_LIBRARY_PATH\")}:",
    "{gdal['gdal_lib_path']}:",
    "{proj['proj_lib_path']}"
  )
  
  # attempt to set LD_LIBRARY_PATH
  tryCatch(
    Sys.setenv(LD_LIBRARY_PATH = new_path),
    error = function(cond) {
      message("Unable to set LD_LIBRARY_PATH to;\n")
      message(new_path)
      stop(cond)
    }
  )
  
  message(glue::glue("LD_LIBRARY_PATH successfully amended"))
  
  # Specify additional proj path in which pkg-config should look for .pc files
  Sys.setenv(PKG_CONFIG_PATH = proj['proj_env_path'])
  
  message("PKG_CONFIG_PATH added as environment variable")
  
  # Specify the path to GDAL data
  Sys.setenv(GDAL_DATA = gdal['gdal_env_path'])
  
  message("GDAL_DATA added as environment variable")
  
  .PHSGeo_env = new.env()
  
  PHSGeo_deps = list(
    gdal = gdal,
    proj = proj,
    geos = geos
    )
  
  assign(".PHSGeo_env", .PHSGeo_env, envir = .GlobalEnv)
  assign("PHSGeo_deps", PHSGeo_deps, envir = .PHSGeo_env)
  
  return(invisible())
}


._path_to_lib = function(lib) {
  
  usr_contains = list.dirs("/usr", recursive = FALSE, full.names = FALSE)
  
  candidates = usr_contains[grepl(lib, usr_contains)]
  
  if (length(candidates) < 1) {
    stop(glue::glue("No viable installation of '{lib}' found in '/usr/' directory"))
  }
  
  return(candidates)
}


._get_gdal = function(...) {
  
  candidates = ._path_to_lib("gdal")
  
  use_ver = NULL
  
  for (ver in candidates) {
    
    p_1 = glue::glue("/usr/{ver}/lib")
    p_2 = glue::glue("/usr/{ver}/share/gdal")
    p_3 = glue::glue("/usr/{ver}/bin/gdal-config")
    p_4 = glue::glue("/usr/{ver}/lib/libgdal.so")
    
    if (all(dir.exists(c(p_1, p_2))) & all(file.exists(c(p_3, p_4)))) {
      use_ver = ver
      break
    }
  }
  
  if (is.null(use_ver)) {
    stop(glue::glue("No viable installation of 'gdal' found in '/usr/' directory"))
  }
  
  return(c(gdal_lib_path = p_1,  gdal_env_path = p_2, 
           gdal_config_path = p_3, gdal_dyn = p_4))
  
}


._get_proj = function(...) {
  
  candidates = ._path_to_lib("proj")
  
  use_ver = NULL
  
  for (ver in candidates) {
    
    p_1 = glue::glue("/usr/{ver}/lib")
    p_2 = glue::glue("/usr/{ver}/lib/pkgconfig")
    p_3 = glue::glue("/usr/{ver}/include")
    
    if (all(dir.exists(c(p_1, p_2, p_3)))) {
      use_ver = ver
      break
    }
  }
  
  if (is.null(use_ver)) {
    stop(glue::glue("No viable installation of 'proj' found in '/usr/' directory"))
  }
  
  return(c(proj_lib_path = p_1,  proj_env_path = p_2,
           proj_config_path_1 = p_1, proj_config_path_2 = p_3))
  
}


._get_geos = function(...) {
  
  candidates = ._path_to_lib("geos")
  
  use_ver = NULL
  
  for (ver in candidates) {
    
    p_1 = glue::glue("/usr/{ver}/bin/geos-config")
    p_2 = glue::glue("/usr/{ver}/lib64/libgeos_c.so")
    
    if (all(file.exists(c(p_1, p_2)))) {
      use_ver = ver
      break
    }
  }
  
  if (is.null(use_ver)) {
    stop(glue::glue("No viable installation of 'geos' found in '/usr/' directory"))
  }
  
  return(c(proj_config_path = p_1,  geos_dyn = p_2))
  
}
