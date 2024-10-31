library(bookdown)

library(knitr)
library(DT)
library(kableExtra)

library(data.table)
library(sf)
library(leaflet)

retrieve_fr_db <- FALSE

# connect to database if retrieving info from DB (connect as NAPMD readonly user)
if (retrieve_fr_db) {
  library(cardatdbtools)
  ch <- cardatdbtools::connect2postgres2(
    database = "DB",
    host = "HOST",
    user = "USER"
  )
}
render_book("Rmd/",
            gitbook(
              split_by = "chapter",
              self_contained = FALSE,
              config = list(sharing = NULL, toc = list(collapse = "section"))
            ),
            params = list(retrieve_fr_db = retrieve_fr_db)) # create connection beforehand if TRUE
dbDisconnect(ch)

# clear old files from project directory and move rendered files over
fs_old <- c(list.files(".", pattern = ".html$"),
            "reference-keys.txt",
            "search_index.json"
)
for (f in fs_old){
  if(file.exists(f)) file.remove(f)
}
if(dir.exists("libs")) unlink("libs", recursive = T)

fs <- list.files("Rmd/_book/", full.names = T)
for (f in fs) {
  #f <- fs[1]
  file.rename(f, gsub("Rmd/_book/", "", f))
}

## browseURL("index.html")
