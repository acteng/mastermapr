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
#' mm_data = mm_read(directory, pattern = "RoadLink")
#' nrow(mm_data) # 46000
#' names(mm_data)
#' }
mm_read = function(directory = ".", f = NULL, pattern = "Road_FULL", n_files = 1) {
  if (is.null(f)) {
    f = mm_list(directory, pattern, full.names = TRUE)
    if(n_files < length(f)) {
      f = f[seq(n_files)]
    }
  }
  if(length(f) == 1) {
    geo_data = sf::read_sf(f)
  } else {
    stop("Reading multiple files not yet supported")
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