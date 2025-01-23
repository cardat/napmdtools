#' Retrieve NAPMD hourly monitor data for given station and variable
#'
#' Retrieve hourly monitor data of specified station and variable for range of dates from \code{start_time_utc} to \code{end_time_utc}, inclusive.
#'
#' @param station_id Integer. NAPMD station ID number (see \code{\link{list_air_pollution_monitors}})
#' @param variable Character. Variable name (see \code{\link{get_variables}})
#' @param start_time_utc Character string in YYYY-MM-DD HH:MM:SS format (UTC timezone)
#' @param end_time_utc Character string in YYYY-MM-DD HH:MM:SS format (UTC timezone)
#' @param username NAPMD API username
#' @param password NAPMD API password
#'
#' @return data.table
#' @export
#'
get_monitor <- function(station_id = 453,
                        variable = "pm25",
                        start_time_utc = "2020-01-01 00:00:00",
                        end_time_utc = "2020-12-31 00:00:00",
                        username = api_key$username,
                        password = api_key$password) {
  
  # Default retrieve data for station 3, PM2.5, an annual slice
  req <- httr::GET("https://napmd.cloud.car-dat.org/get_monitor",query=list(station_id=station_id,
                                                             variable=variable,
                                                             start_time_utc = start_time_utc,
                                                             end_time_utc = end_time_utc,
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
  
  data <- data.table::rbindlist(req,fill=TRUE)
  data$date_time_utc <- as.POSIXct(data$date_time_utc, 
                                   tz = "UTC", 
                                   format = "%Y-%m-%d %H:%M:%S")
  return(data)
}
