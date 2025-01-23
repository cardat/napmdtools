#' Get time range of monitor daily data
#' 
#' Retrieve time range of available daily data for specified station and variable.
#'
#' @param station_id Integer. NAPMD station ID number (see \code{\link{list_air_pollution_monitors}})
#' @param variable Character. Variable name (see \code{\link{get_variables_daily}})
#' @param username NAPMD API username
#' @param password NAPMD API password
#'
#' @return data.table
#' @export 
#'
get_times_daily <- function(station_id = 300,
                      variable = "pm25",
                      username = api_key$username,
                      password = api_key$password) {
  # Retrieve time range for station
  req <- httr::GET("https://napmd.cloud.car-dat.org/get_times_daily",query=list(station_id=station_id,
                                                           variable=variable,
                                                           username=username, 
                                                           password=password,
                                                           datatype="JSON"))
  
  # catch if error
  if (req$status_code != 200) {
    parse_data <- httr::content(req, as = "parsed")
    warning(sprintf("%s: %s", req$status_code, parse_data$error))
    return(NULL)
  }
  
  req <- httr::content(req,as="parsed")
  st_times <- data.table::rbindlist(req,fill=TRUE)
  return(st_times)
}
