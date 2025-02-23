#' Get monitor info
#' 
#' Retrieve station ID, name and spatial information for specified state. Latitudes and longitudes are given in GDA94 coordinate reference system (EPSG:4283).
#'
#' @param state Character. State abbreviation (one of "ACT", "NSW", "NT", "QLD", "SA", "TAS", "WA", "VIC").
#' @param username NAPMD API username
#' @param password NAPMD API password
#'
#' @return data.table
#' @export
#'
list_air_pollution_monitors <- function(
    state="ACT"
    ,
    username = api_key$username
    ,
    password = api_key$password
){

# Retrieve all stations
req <- httr::GET("https://napmd.cloud.car-dat.org/list_air_pollution_monitors",
           query=list(state=state,
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
station_list <- data.table::rbindlist(req,fill=TRUE)
return(station_list)
}