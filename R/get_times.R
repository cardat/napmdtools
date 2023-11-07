get_times <- function(
    station_id=453
    ,
    variable="pm25"
    ,
    username = api_key$username
    ,
    password = api_key$password
){
  # Retrieve time range for station
  req <- httr::GET("https://napmd.cloud.car-dat.org/get_times",query=list(station_id=station_id,
                                                           variable=variable,
                                                           username=username, 
                                                           password=password,
                                                           datatype="JSON"))
  req <- httr::content(req,as="parsed")
  st_times <- data.table::rbindlist(req,fill=TRUE)
  return(st_times)
}