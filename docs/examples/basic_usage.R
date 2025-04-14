# Example usage of the standalone MediaWiki parser

# Load the parser
source("../../src/R/mediawiki_parser.R")

# Example 1: Basic formatting
wikitext1 <- "'''Bold text''' and ''italic text''"
html1 <- convert_wikitext_to_html(wikitext1)
cat("Example 1 - Basic formatting:\n", html1, "\n\n")

# Example 2: Links and images
wikitext2 <- "[[Main Page|Home]] and [[File:example.jpg|thumb|Image caption]]"
result2 <- convert_wikitext_with_metadata(wikitext2)
cat("Example 2 - Links and images:\n")
cat("HTML:", result2$text, "\n")
cat("Links:", paste(names(result2$links), collapse=", "), "\n")
cat("Images:", paste(result2$images, collapse=", "), "\n\n")

# Example 3: Tables
wikitext3 <- "{|
|+ Caption
|-
! Header 1 !! Header 2
|-
| Cell 1 || Cell 2
|-
| Cell 3 || Cell 4
|}"
html3 <- convert_wikitext_to_html(wikitext3)
cat("Example 3 - Tables:\n", html3, "\n\n")

# Example 4: Templates and magic words
wikitext4 <- "{{CURRENTYEAR}} - {{SITENAME}}"
html4 <- convert_wikitext_to_html(wikitext4)
cat("Example 4 - Templates and magic words:\n", html4, "\n")