#' Retrieve NAPMD daily monitor data
#'
#' Retrieve daily monitor data from a date range (\code{start_date} to \code{end_date}, inclusive) for a specified station and variable.
#' 
#' @param station_id Integer. NAPMD station ID number (see \code{\link{list_air_pollution_monitors}})
#' @param variable Character. Variable name (see \code{\link{get_variables_daily}})
#' @param start_date Date format or character string in YYYY-MM-DD format.
#' @param end_date Date format or character string in YYYY-MM-DD format.
#' @param username NAPMD API username
#' @param password NAPMD API password
#'
#' @return data.table
#' @export
#'
get_monitor_daily <- function(station_id = 300,
                        variable = "pm25",
                        start_date = "2020-01-01",
                        end_date = "2020-02-01",
                        username = api_key$username,
                        password = api_key$password) {
  
  start_time_utc <- as.POSIXct(as.Date(start_date, "%Y-%m-%d"), tz = "UTC")
  end_time_utc <- as.POSIXct(as.Date(end_date, "%Y-%m-%d"), tz = "UTC")
  
  req <- httr::GET("https://napmd.cloud.car-dat.org/get_monitor_daily",query=list(station_id=station_id,
                                                             variable=variable,
                                                             start_time_utc = start_time_utc,
                                                             end_time_utc = end_time_utc,
                                                             username=username, 
                                                             password=password,
                                                             datatype="JSON"))
  # catch if error
  if(req$status_code != 200){
    parse_data <- httr::content(req,as="parsed")
    warning(sprintf("Error %s: %s", req$status_code, parse_data$error))
    return(NULL)
  }
  
  req <- httr::content(req,as="parsed")
  
  data <- data.table::rbindlist(req,fill=TRUE)
  data$date_time_utc <- as.POSIXct(data$date_time_utc, 
                                   tz = "UTC", 
                                   format = "%Y-%m-%d %H:%M:%S")
  return(data)
}
