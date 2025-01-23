#' Get variables of monitor daily data
#'
#' Retrieve available variables and corresponding units of daily data for specified station.
#'
#' @param station_id Integer. NAPMD station ID number (see \code{\link{list_air_pollution_monitors}})
#' @param username NAPMD API username
#' @param password NAPMD API password
#'
#' @return data.table
#' @export
#' 
get_variables_daily <- function(
    station_id = 300,
    username = api_key$username,
    password = api_key$password
){
  
  req <- httr::GET("https://napmd.cloud.car-dat.org/get_variables_daily",query=list(station_id=station_id,
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
