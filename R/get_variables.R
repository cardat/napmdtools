get_variables <- function(
    station_id = 453
    ,
    username = api_key$username
    ,
    password = api_key$password
){
  # Retrieve varibles for station 3
  req <- httr::GET("https://napmd.cloud.car-dat.org/get_variables",query=list(station_id=station_id,
                                                                             username=username, 
                                                                             password=password,
                                                                             datatype="JSON"))
  req <- httr::content(req,as="parsed")
  st_vars <- data.table::rbindlist(req,fill=TRUE)
  return(st_vars)
}
