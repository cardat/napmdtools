list_air_pollution_monitors <- function(
    state="ACT"
){

# Retrieve all stations
req <- httr::GET("http://203.101.229.148/list_air_pollution_monitors",
           query=list(state=state,
                      datatype="JSON"))

req <- httr::content(req,as="parsed")
station_list <- data.table::rbindlist(req,fill=TRUE)
return(station_list)
}