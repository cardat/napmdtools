
.onLoad <- function(libname, pkgname) {
  msg.version <- sprintf("napmdtools %s", packageVersion("napmdtools"))
  
  url_conditions <- ifelse(
    "cli" %in% rownames(installed.packages()),
    cli::style_hyperlink(text = "https://cardat.github.io/napmdtools/conditions-of-use.html",
                         url =  "https://cardat.github.io/napmdtools/conditions-of-use.html"),
    "https://cardat.github.io/napmdtools/conditions-of-use.html")
  msg.conditions <- sprintf("CONDITIONS OF USE: Your use of NAPMD data must adhere to the conditions of use and be appropriately attributed. Read in full at %s", url_conditions)
              
  packageStartupMessage(paste(list(msg.version, msg.conditions), collapse = "\n"))
  invisible()
}
