#' Import a directory containing MasterMap data
#' 
#' See  https://beta.ordnancesurvey.co.uk/products/os-mastermap-highways-network-roads#technical
#' for technical details (Highway data).
#' 
#' RoadLink, RoadNode, and Street layers have geometries.
#' 
#'
#' @param directory The directory of data files to read
#' @param pattern Text string identifying which parts of the road network
#'   to import. Options including FerryLink, FerryNode, FerryTerminal,
#'   Road_FULL, RoadJunctio, RoadLink_FU, RoadNode_FU, and Street_FULL
#' @param n_files How many files to read? 1 by default.
#' @param f Full file names to read-in
#' @return sf data frame
#' @export
#'
#' @examples
#' if(FALSE) {
#' # Change directory to the location where you store data:
#' directory = "path/to/data"
#' files = mm_list(directory, pattern = "*")
#' # file_strings = stringr::str_sub(files, 16, 26)
#' # [1] ""            "FerryLink_F" "FerryNode_F" "FerryTermin"
#' # [5] "Road_FULL_0" "RoadJunctio" "RoadLink_FU" "RoadNode_FU"
#' # [9] "Street_FULL"
#' # unique(file_strings)
#' files = mm_list(directory, pattern = "RoadLink")
#' head(files)
#' mm_data_small = mm_read(directory, pattern = "RoadLink")
#' nrow(mm_data_small) # 46000
#' sf::st_write(mm_data_small, "mm_data_small.gpkg")
#' names(mm_data)
#' plot(mm_data$centrelineGeometry)
#' # Multiple files
#' mm_data = mm_read(directory, pattern = "RoadLink", n_files = 3)
#' mm_data
#' plot(mm_data$centrelineGeometry)
#' }
mm_read = function(directory = ".", f = NULL, pattern = "Road_FULL", n_files = 1) {
  if (is.null(f)) {
    f = mm_list(directory, pattern, full.names = TRUE)
    # Keep gz files:
    f = f[grepl(pattern = ".gml.gz", x = f)]
    # Remove gfs files:
    f = f[!grepl(pattern = ".gfs|.properties", x = f)]
    message(length(f), " files available, starting with: ", f[1])
    if(n_files < length(f)) {
      f = f[seq(n_files)]
    }
  }
  if(length(f) == 1) {
    geo_data = sf::read_sf(f)
  } else {
    message("Reading in data")
    geo_data_list = pbapply::pblapply(X = f, FUN = sf::read_sf)
    message("Combining data")
    geo_data = fastrbindsf(geo_data_list)
  }
  geo_data
}
#' @rdname mm_read
#' @param full.names Show the full file name? No, meaning just file names
#'   is default.
#' @export
mm_list = function(directory, pattern = "Road_FULL", full.names = FALSE) {
  f = list.files(directory, pattern = pattern, full.names = full.names)
  f
}

#' Rapidly bind sf data frames
#' 
#' See https://gist.github.com/kadyb/8a32c432a7b497b697379b483a8216d1
#' And https://github.com/r-spatial/sf/issues/798
#' 
#' @param x List of sf data frames
#' @param check Check that CRS and column names are the same?
#' @return sf data frame
#' @export
fastrbindsf = function(x, check = FALSE) {
  if (length(x) == 0) stop("Empty list")
  if (isTRUE(check)) {
    ref_crs = sf::st_crs(x[[1]])
    ref_colnames = colnames(x[[1]])
    for (i in seq_len(length(x))) {
      if (isFALSE(sf::st_crs(x[[i]]) == ref_crs)) stop("Diffrent CRS")
      if (isFALSE(all(colnames(x[[i]]) == ref_colnames))) stop("Diffrent columns")
    }
  }
  geom_name = attr(x[[1]], "sf_column")
  x = collapse::unlist2d(x, idcols = FALSE, recursive = FALSE)
  x[[geom_name]] = sf::st_sfc(x[[geom_name]], recompute_bbox = TRUE)
  x = sf::st_as_sf(x)
}