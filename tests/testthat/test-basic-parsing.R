# Test basic wikitext parsing functionality

test_that("basic formatting works", {
  # Test bold and italic
  expect_match(
    convert_wikitext_to_html("'''Bold'''"),
    "<strong>Bold</strong>",
    fixed = TRUE
  )
  
  expect_match(
    convert_wikitext_to_html("''Italic''"),
    "<em>Italic</em>",
    fixed = TRUE
  )
  
  # Test combined formatting
  expect_match(
    convert_wikitext_to_html("'''''Bold Italic'''''"),
    "<strong><em>Bold Italic</em></strong>",
    fixed = TRUE
  )
})

test_that("links are parsed correctly", {
  result <- convert_wikitext_with_metadata("[[Main Page|Home]]")
  
  # Check HTML output
  expect_match(
    result$text,
    '<a href="Main_Page">Home</a>',
    fixed = TRUE
  )
  
  # Check metadata
  expect_true("Main_Page" %in% names(result$links))
})

test_that("headers create proper HTML and TOC", {
  wikitext <- "
== Section 1 ==
Some text
=== Subsection 1.1 ===
More text
== Section 2 ==
Final text
"
  result <- convert_wikitext_with_metadata(wikitext)
  
  # Check header HTML
  expect_match(result$text, "<h2", fixed = TRUE)
  expect_match(result$text, "<h3", fixed = TRUE)
  
  # Check sections metadata
  expect_true(length(result$sections) >= 3)
})

test_that("lists are formatted correctly", {
  wikitext <- "
* Item 1
* Item 2
** Subitem 2.1
* Item 3
"
  html <- convert_wikitext_to_html(wikitext)
  
  # Check list structure
  expect_match(html, "<ul>", fixed = TRUE)
  expect_match(html, "<li>", fixed = TRUE)
  expect_true(stringr::str_count(html, "<ul>") >= 2)  # At least one nested list
})

test_that("tables are parsed properly", {
  wikitext <- "{|
|+ Caption
|-
! Header 1 !! Header 2
|-
| Cell 1 || Cell 2
|}"
  
  html <- convert_wikitext_to_html(wikitext)
  
  # Check table structure
  expect_match(html, "<table", fixed = TRUE)
  expect_match(html, "<caption>Caption</caption>", fixed = TRUE)
  expect_match(html, "<th", fixed = TRUE)
  expect_match(html, "<td", fixed = TRUE)
})

test_that("images are handled correctly", {
  result <- convert_wikitext_with_metadata(
    "[[File:example.jpg|thumb|Caption text]]"
  )
  
  # Check metadata
  expect_true("example.jpg" %in% result$images)
  
  # Check HTML output includes image tag
  expect_match(result$text, "<img", fixed = TRUE)
  expect_match(result$text, "Caption text", fixed = TRUE)
})

test_that("categories are extracted", {
  result <- convert_wikitext_with_metadata(
    "Some text\n[[Category:Test]]\n[[Category:Example]]"
  )
  
  # Check categories in metadata
  expect_true("Test" %in% names(result$categories))
  expect_true("Example" %in% names(result$categories))
})

test_that("error handling works", {
  # Test invalid wikitext (unmatched tags)
  expect_error(
    convert_wikitext_to_html("'''Unmatched bold"),
    NA  # Should not error, but handle gracefully
  )
  
  # Test empty input
  expect_error(
    convert_wikitext_to_html(""),
    NA  # Should handle empty input gracefully
  )
  
  # Test NULL input
  expect_error(convert_wikitext_to_html(NULL))
})

test_that("special characters are handled properly", {
  # Test HTML entities
  expect_match(
    convert_wikitext_to_html("&amp; &lt; &gt;"),
    "&amp; &lt; &gt;",
    fixed = TRUE
  )
  
  # Test Unicode
  expect_match(
    convert_wikitext_to_html("Unicode: ñ é ü"),
    "Unicode: ñ é ü",
    fixed = TRUE
  )
})