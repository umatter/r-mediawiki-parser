#' Convert wikitext to HTML using MediaWiki's parser
#'
#' @param wikitext Character string containing wikitext markup
#' @param format Output format ('html' or 'json')
#' @return If format is 'html', returns HTML string. If format is 'json',
#'         returns a list containing parsed text and metadata
#' @export
convert_wikitext <- function(wikitext, format = c("html", "json")) {
    format <- match.arg(format)
    
    # Escape the wikitext for shell command
    escaped_wikitext <- gsub('"', '\\"', wikitext)
    
    # Build the command
    script_path <- file.path(dirname(sys.frame(1)$ofile), "..", "mediawiki_parser.php")
    
    # Execute the command
    result <- tryCatch({
        system2("php", args = c(
            script_path,
            "--wikitext", escaped_wikitext,
            "--format", format
        ), stdout = TRUE, stderr = TRUE)
        
        if (format == "json") {
            jsonlite::fromJSON(paste(result, collapse = "\n"))
        } else {
            paste(result, collapse = "\n")
        }
    }, error = function(e) {
        stop("Error executing parser: ", e$message)
    })
    
    return(result)
}

#' Convert wikitext to HTML with full MediaWiki parsing
#'
#' @param wikitext Character string containing wikitext markup
#' @return HTML string
#' @export
convert_wikitext_to_html <- function(wikitext) {
    convert_wikitext(wikitext, format = "html")
}

#' Convert wikitext to HTML and get metadata
#'
#' @param wikitext Character string containing wikitext markup
#' @return List containing parsed HTML and metadata (links, images, etc.)
#' @export
convert_wikitext_with_metadata <- function(wikitext) {
    convert_wikitext(wikitext, format = "json")
}