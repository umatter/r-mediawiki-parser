#!/bin/bash

# Example of using the parser from command line

# Basic HTML output
echo "Example 1: Basic HTML output"
php ../../src/mediawiki_parser.php --wikitext="'''Bold''' and ''italic''"
echo

# JSON output with metadata
echo "Example 2: JSON output with metadata"
php ../../src/mediawiki_parser.php --wikitext="[[Link]] and [[File:image.jpg]]" --format=json
echo

# Complex example with tables
echo "Example 3: Table parsing"
php ../../src/mediawiki_parser.php --wikitext="{|
|+ Caption
|-
! Header 1 !! Header 2
|-
| Cell 1 || Cell 2
|}" --format=json
echo