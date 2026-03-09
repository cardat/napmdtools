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
  
  req <- httr2::request("https://napmd.cloud.car-dat.org/") |>
    httr2::req_url_path_append("get_variables_daily") |>
    httr2::req_url_query(
      station_id=station_id,
      username=username, 
      password=password,
      datatype="JSON"
    ) |>
    httr2::req_error(is_error = \(resp) FALSE) |>
    httr2::req_retry(max_tries = 5, 
                     is_transient = \(resp) httr2::resp_status(resp) %in% c(429, 500, 503))
  
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
