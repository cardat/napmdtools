#' Get variables of monitor hourly data
#'
#' Retrieve available variables of hourly data for specified station.
#'
#' @param station_id Integer. NAPMD station ID number (see \code{\link{list_air_pollution_monitors}})
#' @param username NAPMD API username
#' @param password NAPMD API password
#'
#' @return data.table
#' @export
#'
get_variables <- function(
    station_id = 453,
    username = api_key$username,
    password = api_key$password
){
  # Retrieve varibles for station 3
  req <- httr::GET("https://napmd.cloud.car-dat.org/get_variables",query=list(station_id=station_id,
                                                                             username=username, 
                                                                             password=password,
                                                                             datatype="JSON"))
  
  # catch if error
  if(req$status_code != 200){
    parse_data <- httr::content(req,as="parsed")
    warning(sprintf("%s: %s", req$status_code, parse_data$error))
    return(NULL)
  }
  
  req <- httr::content(req,as="parsed")
  st_vars <- data.table::rbindlist(req,fill=TRUE)
  return(st_vars)
}
