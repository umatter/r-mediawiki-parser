# Example of bulk processing wikitext files

# Load the parser
source("../../src/R/mediawiki_parser.R")

# Function to process a single file
process_wikitext_file <- function(file_path) {
    # Read the file
    wikitext <- readLines(file_path, warn = FALSE)
    wikitext <- paste(wikitext, collapse = "\n")
    
    # Get file name without path
    file_name <- basename(file_path)
    
    # Parse with metadata
    cat("Processing", file_name, "...\n")
    result <- convert_wikitext_with_metadata(wikitext)
    
    # Return structured results
    list(
        file = file_name,
        html = result$text,
        links = length(result$links),
        images = length(result$images),
        categories = length(result$categories)
    )
}

# Example usage:
# Assuming you have some .wiki files in a directory:

# Create example files for demonstration
dir.create("wiki_files", showWarnings = FALSE)
writeLines("'''Page 1''' with [[link1]] and [[File:img1.jpg]]", "wiki_files/page1.wiki")
writeLines("'''Page 2''' with [[link2]] and [[Category:Test]]", "wiki_files/page2.wiki")

# Process all wiki files in directory
wiki_files <- list.files("wiki_files", pattern = "\\.wiki$", full.names = TRUE)
results <- lapply(wiki_files, process_wikitext_file)

# Print summary
cat("\nProcessing Summary:\n")
cat("==================\n")
for (result in results) {
    cat(sprintf(
        "%s: %d links, %d images, %d categories\n",
        result$file,
        result$links,
        result$images,
        result$categories
    ))
}

# Clean up example files
unlink("wiki_files", recursive = TRUE)