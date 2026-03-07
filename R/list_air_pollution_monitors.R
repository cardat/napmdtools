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
req <- httr2::request("https://napmd.cloud.car-dat.org/") |>
  httr2::req_url_path_append("list_air_pollution_monitors") |>
  httr2::req_url_query(
    state = state
    username = username,
    password = password,
    datatype = "JSON"
  ) |>
  httr2::req_error(is_error = \(resp) FALSE) |>
  httr2::req_retry(max_tries = 5)

resp <- httr2::req_perform(req)

# catch if error, display message
if (httr2::resp_is_error(resp)) {
  parse_data <- httr2::resp_body_json(resp)
  warning(sprintf("Error %s: %s", resp$status_code, parse_data$error))
  return(NULL)
}

dat_resp <- httr2::resp_body_json(resp)
dat <- data.table::rbindlist(dat_resp, fill = TRUE)

return(dat)
}