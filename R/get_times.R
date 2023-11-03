get_times <- function(
    station_id=453
    ,
    variable="pm25"
){
  # Retrieve time range for station
  req <- httr::GET("http://203.101.229.148/get_times",query=list(station_id=station_id,
                                                           variable=variable,
                                                           datatype="JSON"))
  req <- httr::content(req,as="parsed")
  st_times <- data.table::rbindlist(req,fill=TRUE)
  return(st_times)
}