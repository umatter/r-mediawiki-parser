# R MediaWiki Parser

[![R-CMD-check](https://github.com/umatter/r-mediawiki-parser/workflows/R-CMD-check/badge.svg)](https://github.com/umatter/r-mediawiki-parser/actions)
[![CRAN status](https://www.r-pkg.org/badges/version/rmediawiki)](https://CRAN.R-project.org/package=rmediawiki)

An R package that provides direct access to MediaWiki's parser functionality without requiring a running MediaWiki server. Convert wikitext to HTML, extract metadata, and process multiple files efficiently.

## Features

- **Full MediaWiki Parsing**: Support for all MediaWiki markup features
  - Basic formatting (bold, italic, etc.)
  - Links (internal, external, interwiki)
  - Images and media files
  - Templates
  - Tables
  - Categories
  - Magic words
  
- **Simple R Interface**: Easy-to-use functions for common tasks
  - `convert_wikitext_to_html()`: Basic wikitext to HTML conversion
  - `convert_wikitext_with_metadata()`: Get HTML and metadata (links, images, etc.)
  
- **Command-line Interface**: Direct access through PHP script
- **Bulk Processing**: Efficiently handle multiple files
- **Metadata Extraction**: Access links, images, categories, and more

## Installation

### Prerequisites

1. PHP 7.4 or later
2. Composer (PHP package manager)
3. R 3.5.0 or later

### Installing PHP Dependencies

```bash
# In the package directory
composer install
```

### Installing the R Package

```R
# Install from GitHub
remotes::install_github("umatter/r-mediawiki-parser")
```

## Usage

### Basic Usage

```R
library(rmediawiki)

# Simple conversion
html <- convert_wikitext_to_html("'''Bold''' and ''italic'' text")

# Get parsing results with metadata
result <- convert_wikitext_with_metadata("[[Link]] and [[File:image.jpg]]")
print(result$text)     # HTML content
print(result$links)    # List of links
print(result$images)   # List of images
```

### Bulk Processing

```R
# Process multiple files
files <- list.files("wikitext_dir", pattern = "\\.wiki$", full.names = TRUE)
results <- lapply(files, function(file) {
    wikitext <- readLines(file, warn = FALSE)
    convert_wikitext_with_metadata(paste(wikitext, collapse = "\n"))
})
```

### Command Line Usage

```bash
php src/mediawiki_parser.php --wikitext="'''Bold''' text" --format=html
php src/mediawiki_parser.php --wikitext="[[Link]] text" --format=json
```

## API Reference

### R Functions

#### convert_wikitext_to_html()

Convert wikitext to HTML.

```R
convert_wikitext_to_html(wikitext)
```

- `wikitext`: Character string containing wikitext markup
- Returns: HTML string

#### convert_wikitext_with_metadata()

Convert wikitext to HTML and extract metadata.

```R
convert_wikitext_with_metadata(wikitext)
```

- `wikitext`: Character string containing wikitext markup
- Returns: List containing:
  - `text`: HTML content
  - `links`: Internal and external links
  - `images`: Image references
  - `categories`: Category assignments
  - `templates`: Template usage
  - `sections`: Document structure
  - `properties`: Page properties

### PHP Interface

#### StandaloneParser Class

```php
$parser = new StandaloneParser();

// Parse wikitext to HTML
$html = $parser->parse($wikitext);

// Parse with metadata
$result = $parser->parseWithMetadata($wikitext);
```

## Examples

### Basic Formatting

```R
wikitext <- "
== Section Title ==
'''Bold text''' and ''italic text''

=== Subsection ===
* List item 1
* List item 2
  * Nested item

[[Link to page|Custom text]]
"

html <- convert_wikitext_to_html(wikitext)
```

### Tables and Templates

```R
wikitext <- "
{|
|+ Caption
|-
! Header 1 !! Header 2
|-
| Cell 1 || Cell 2
|-
| Cell 3 || Cell 4
|}

{{Template|param=value}}
"

result <- convert_wikitext_with_metadata(wikitext)
```

### Images and Categories

```R
wikitext <- "
[[File:example.jpg|thumb|Caption text]]

Some text about the topic.

[[Category:Example]]
[[Category:Documentation]]
"

result <- convert_wikitext_with_metadata(wikitext)
print(result$images)
print(result$categories)
```

## Contributing

Contributions are welcome! Please feel free to submit a Pull Request.

### Development Setup

1. Clone the repository:
```bash
git clone https://github.com/umatter/r-mediawiki-parser.git
cd r-mediawiki-parser
```

2. Install dependencies:
```bash
composer install  # PHP dependencies
```

3. Run tests:
```R
devtools::test()  # R tests
```

### Running Tests

The package includes comprehensive tests for both R and PHP components:

```R
# Run R tests
devtools::test()

# Run PHP tests
composer test
```

## License

This project is licensed under the GNU General Public License v2.0 or later - see the [LICENSE](LICENSE) file for details.

## Credits

This package includes code from the [MediaWiki](https://www.mediawiki.org) project.