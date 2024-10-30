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
  req <- httr::GET("https://napmd.cloud.car-dat.org/get_slice_all",query=list(variable=variable,
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