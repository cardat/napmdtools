list_air_pollution_monitors <- function(
    state="ACT"
){

# Retrieve all stations
req <- GET("http://203.101.229.148/list_air_pollution_monitors",
           query=list(state=state,
                      datatype="JSON"))

req <- content(req,as="parsed")
station_list <- rbindlist(req,fill=TRUE)
return(station_list)
}