get_slice_all <- function(
    variable="pm25"
    ,
    time_utc = "2019-11-03 15:00:00"
    ,
    state="NSW"
){
# Retrieve data a given hour
req <- httr::GET("http://203.101.229.148/get_slice_all",query=list(variable=variable,
                                                             time_utc = time_utc,
                                                             state=state,
                                                             datatype="JSON"))
req <- httr::content(req,as="parsed")
data <- data.table::rbindlist(req,fill=TRUE)
return(data)
}