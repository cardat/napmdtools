#' Setup API Credentials
#' 
#' Creates a template YAML file for API credentials and adds it to .gitignore
#' @param dir Character. Directory to store credentials. Default is "private"
#' @return Invisibly returns the path to the created YAML file
#' @export
#' @importFrom yaml write_yaml
#' @importFrom utils askYesNo
create_api_key <- function(dir = "private") {
  # Check if yaml package is installed
  if (!requireNamespace("yaml", quietly = TRUE)) {
    stop("Package 'yaml' is needed for this function to work. Please install it.",
         call. = FALSE)
  }
  
  # Create private directory if it doesn't exist
  if (!dir.exists(dir)) {
    dir.create(dir, recursive = TRUE)
    message("Created directory: ", dir)
  }
  
  # Define the path for the api key file
  api_file <- file.path(dir, "api_key.yaml")
  
  # Check if file already exists
  if (file.exists(api_file)) {
    overwrite <- utils::askYesNo(
      paste("API credentials file already exists at", api_file, 
            "Do you want to overwrite it?"))
    if (!isTRUE(overwrite)) {
      message("Setup cancelled.")
      return(invisible(api_file))
    }
  }
  
  # Prompt for credentials
  cat("Please enter your API credentials:\n")
  username <- readline("username: ")
  password <- readline("password: ")
  
  # Create credentials list
  credentials <- list(
    username = username,
    password = password,
    created_at = Sys.time()
  )
  
  # Write to YAML file
  yaml::write_yaml(credentials, api_file)
  message("Created API credentials file at: ", api_file)
  
  # Update .gitignore section of the function:
  gitignore <- ".gitignore"
  ignore_entry <- file.path(dir, "api_key.yaml")
  
  if (file.exists(gitignore)) {
    current_ignores <- readLines(gitignore, warn = FALSE)
    if (!ignore_entry %in% current_ignores) {
      # Ensure there's a newline at the end
      write(paste0(ignore_entry, "\n"), gitignore, append = TRUE)
      message("Added ", ignore_entry, " to .gitignore")
    }
  } else {
    write(paste0(ignore_entry, "\n"), gitignore)
    message("Created .gitignore and added ", ignore_entry)
  }
  
  invisible(api_file)
}
