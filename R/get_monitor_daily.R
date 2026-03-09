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
  
  req <- httr2::request("https://napmd.cloud.car-dat.org/") |>
    httr2::req_url_path_append("get_monitor_daily") |>
    httr2::req_url_query(
      station_id=station_id,
      variable=variable,
      start_time_utc = start_time_utc,
      end_time_utc = end_time_utc,
      username = username,
      password = password,
      datatype = "JSON"
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
  # format date/datetime correctly
  data.table::set(dat, j = "date", value = as.Date(dat[["date"]]))
  # midnights return without HMS, add before converting type
  data.table::set(dat, 
                  which(grepl("^[0-9]{4}-[0-9]{2}-[0-9]{2}$", dat[["date_time_utc"]])), 
                  j = "date_time_utc", 
                  value = paste(dat[["date_time_utc"]], "00:00:00"))
  data.table::set(dat,
                  j = "date_time_utc",
                  value = as.POSIXct(dat[["date_time_utc"]], 
                                     tz = "UTC", 
                                     format = "%Y-%m-%d %H:%M:%S"))
  
  return(dat)
}