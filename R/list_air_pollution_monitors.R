list_air_pollution_monitors <- function(
    state="ACT"
    ,
    username = api_key$username
    ,
    password = api_key$password
){

# Retrieve all stations
req <- httr::GET("https://napmd.cloud.car-dat.org/list_air_pollution_monitors",
           query=list(state=state,
                      username=username, 
                      password=password,
                      datatype="JSON"))

req <- httr::content(req,as="parsed")
station_list <- data.table::rbindlist(req,fill=TRUE)
return(station_list)
}