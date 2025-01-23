#' Retrieve slice of NAPMD daily monitor data
#'
#' Retrieve daily monitor data from all stations for a specified state, variable and date.
#'
#' @param variable Character. Variable name (see \code{\link{get_variables_daily}})
#' @param date Date format or character string in YYYY-MM-DD format.
#' @param state Character. State abbreviation (one of "ACT", "NSW", "NT", "QLD", "SA", "TAS", "WA", "VIC").
#' @param username NAPMD API username
#' @param password NAPMD API password
#'
#' @return data.table
#' @export
#'
get_slice_daily <- function(variable = "pm25"
                          ,
                          date = "2012-01-01"
                          ,
                          state = "TAS"
                          ,
                          username = api_key$username
                          ,
                          password = api_key$password) {
  
  # API requires UTC time
  time_utc <- as.POSIXct(as.Date(date, "%Y-%m-%d"), tz = "UTC")
  # Retrieve data a given day
  req <- httr::GET("https://napmd.cloud.car-dat.org/get_slice_daily",query=list(variable=variable,
                                                             time_utc = time_utc,
                                                             state=state,
                                                             username=username, 
                                                             password=password,
                                                             datatype="JSON"))
  # catch if error
  if (req$status_code != 200) {
    parse_data <- httr::content(req, as = "parsed")
    warning(sprintf("%s: %s", req$status_code, parse_data$error))
    return(NULL)
  }

  req <- httr::content(req, as = "parsed")
  data <- data.table::rbindlist(req, fill = TRUE)
  return(data)
}
