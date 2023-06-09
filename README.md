# PHSGeo - Helper to install R geospatial packages

This package helps with the installation of geospatial packages;

* sf
* terra
* sp
* raster
* rgdal
* leaflet

The package is written for a highly specific environment and is not intended for
wider usage; the methods provided are unlikely to work in a more general setup.

This package is NOT supported or commissioned by any organisation and usage is
at your own risk as per the license conditions.

## Installation

Install `PHSGeo` from GitHub;

```r
devtools::install_github("https://github.com/jrh-dev/PHSGeo")
```

## Usage

### To install geospatial packages

To install all of the geospatial packages listed above;

```r
PHSGeo::install_geospatial()
```

To install a specific geospatial package from those listed above;

```r
PHSGeo::install_geospatial(pkgs = "sf")
```

To install a subset of geospatial packages from those listed above;

```r
PHSGeo::install_geospatial(pkgs = c("sf", "terra"))
```

If you want to perform a clean installation of the geospatial package
dependencies (R package dependencies NOT system dependencies) run with
`clean = TRUE`;

```r
# to install all packages
PHSGeo::install_geospatial(clean = TRUE)

# to install a specific package
PHSGeo::install_geospatial(pkgs = "sf, clean = TRUE)
```

Please note that using `clean = TRUE` should be a last resort when
installation has proved problematic. Removing and performing a fresh 
installation of all geospatial dependencies will take a long time, is 
typically unnecessary, and the package versions removed will NOT be respected
during re-installation.

No testing has been performed to ascertain compatibility with environment
managers such as `.renv`.

### Post installation - on every usage of geospatial packages

Following installation some changes must be made to the users environment
before the packages can be used. The user must make these changes every time a
geospatial package is used.

The simplest way to ensure the environment is ready to use a geospatial package
is to add `PHSGeo::setup_env()` to every script utilising these packages. The
code should run before geospatial libraries are loaded and the `PHSGeo` package 
should never be loaded with a call to `library()`, always access `PHSGeo` with 
its namespace.

```r
PHSGeo::setup_env()

library(sf)
library(terra)
```

## What does this package do?

Primarily, the package exists to detect the locations of installed system
dependencies for geospatial packages. This ensures that differing lib versions
between users individual sessions should be resolved without the user needing
an understanding of the underlying linux file system.

A number of assumptions have been made about the system on which this package 
will run and compatibility with other systems is not expected.

The package also handles installation of the geospatial packages utilising 
configurations suggested by SME's in the guidance published [here](https://github.com/Public-Health-Scotland/technical-docs/blob/1-write-guidance-on-installing-and-using-geospatial-r-packages-in-posit-workbench/Infrastructure/How%20to%20Install%20and%20Use%20Geospatial%20R%20Packages.md). Whilst this package attempts to ease the 
implementation of the official guidance, users should refer back to that
guidance in the case of doubt.

The package is capable of detecting, removing, and performing a fresh
installation of geospatial package dependencies. However, use of this feature
is discouraged except as a last resort and users may experience inconvenience 
as a result of such action.

