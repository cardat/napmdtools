get_variables <- function(
    station_id = 453
){
  # Retrieve varibles for station 3
  req <- httr::GET("http://napmd.cloud.car-dat.org/get_variables",query=list(station_id=station_id,
                                                              datatype="JSON"))
  req <- httr::content(req,as="parsed")
  st_vars <- data.table::rbindlist(req,fill=TRUE)
  return(st_vars)
}
