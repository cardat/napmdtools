get_monitor <- function(
    station_id=453
    ,
    variable="pm25"
    ,
    start_time_utc = "2020-01-01 00:00:00"
    ,
    end_time_utc = "2020-12-31 00:00:00"
){
  # Retrieve data for station 3, PM2.5, an annual slice
  req <- httr::GET("http://napmd.cloud.car-dat.org/get_monitor",query=list(station_id=station_id,
                                                             variable=variable,
                                                             start_time_utc = start_time_utc,
                                                             end_time_utc = end_time_utc,
                                                             datatype="JSON"))
  req <- httr::content(req,as="parsed")
  data <- data.table::rbindlist(req,fill=TRUE)
  data$date_time_utc <- as.POSIXct(data$date_time_utc)
  return(data)
}