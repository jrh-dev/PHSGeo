

setup_env()


geo_install("terra", geo_config_args = geo_args())

geo_args()

geo_args = function(...) {
  
  args = c(
    ._gdal_config(),
    ._proj_config(),
    ._geos_config()
  )
  
  return(args)
  
}

._gdal_config = function(...) {
  
  gdal_path = ._path_to_lib("gdal")
  
  # Specify the path to GDAL config
  gdal_path = gsub("lib", "bin/gdal-config", gdal_path)
  
  arg = glue::glue("--with-gdal-config={gdal_path}")
  
  return(arg)
  }

._proj_config = function(...) {
  
  proj_path_1 = ._path_to_lib("proj")
  
  # Specify the path to GDAL config
  proj_path_2 = gsub("lib", "include", proj_path_1)
  
  arg_1 = glue::glue("--with-proj-lib={proj_path_1}")
  arg_2 = glue::glue("--with-proj-include={proj_path_2}")
  
  return(c(arg_1, arg_2))
}

._geos_config = function(...) {
  
  geos_path = ._path_to_lib("geos")
  
  # Specify the path to GDAL config
  geos_path = gsub("lib", "bin/geos-config", geos_path)
  
  arg = glue::glue("--with-geos-config={geos_path}")
  
  return(arg)
}
