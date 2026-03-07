#' Retrieve slice of NAPMD hourly monitor data
#'
#' Retrieve daily monitor data from all stations for a specified state, variable and date.
#'
#' @param variable Character. Variable name (see \code{\link{get_variables_daily}})
#' @param time_utc Character string in YYYY-MM-DD HH:MM:SS format (UTC timezone)
#' @param state Character. State abbreviation (one of "ACT", "NSW", "NT", "QLD", "SA", "TAS", "WA", "VIC").
#' @param username NAPMD API username
#' @param password NAPMD API password
#'
#' @return data.table
#' @export
#'
get_slice_all <- function(variable = "pm25"
                          ,
                          time_utc = "2019-11-03 15:00:00"
                          ,
                          state = "NSW"
                          ,
                          username = api_key$username
                          ,
                          password = api_key$password) {
  # Retrieve data a given hour
  req <- httr2::request("https://napmd.cloud.car-dat.org/") |>
    httr2::req_url_path_append("get_slice_all") |>
    httr2::req_url_query(
      variable=variable,
      time_utc = time_utc,
      state=state,
      username=username, 
      password=password,
      datatype="JSON"
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
  dat[, date := as.Date(date)]
  dat[, date_time_utc := as.POSIXct(date_time_utc, 
                                    tz = "UTC", 
                                    format = "%Y-%m-%d %H:%M:%S")]
  
  return(dat)
}