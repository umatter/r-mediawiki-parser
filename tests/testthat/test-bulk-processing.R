# Test bulk processing functionality

test_that("multiple files can be processed", {
  # Create temporary test files
  dir.create("wiki_test_files")
  writeLines("'''File 1''' content", "wiki_test_files/file1.wiki")
  writeLines("'''File 2''' content", "wiki_test_files/file2.wiki")
  
  # Process files
  files <- list.files("wiki_test_files", pattern = "\\.wiki$", full.names = TRUE)
  results <- lapply(files, function(file) {
    wikitext <- readLines(file, warn = FALSE)
    convert_wikitext_to_html(paste(wikitext, collapse = "\n"))
  })
  
  # Check results
  expect_equal(length(results), 2)
  expect_match(results[[1]], "<strong>File 1</strong>", fixed = TRUE)
  expect_match(results[[2]], "<strong>File 2</strong>", fixed = TRUE)
  
  # Clean up
  unlink("wiki_test_files", recursive = TRUE)
})

test_that("large files are handled properly", {
  # Create a large wikitext file
  large_text <- paste(rep("'''Test''' paragraph\n", 1000), collapse = "")
  
  # Process large text
  result <- convert_wikitext_to_html(large_text)
  
  # Check result
  expect_true(nchar(result) > 10000)
  expect_match(result, "<strong>Test</strong>", fixed = TRUE)
})

test_that("concurrent processing works", {
  # Create test data
  texts <- replicate(10, "'''Test''' content", simplify = FALSE)
  
  # Process concurrently using parallel package
  library(parallel)
  cl <- makeCluster(2)
  results <- parLapply(cl, texts, convert_wikitext_to_html)
  stopCluster(cl)
  
  # Check results
  expect_equal(length(results), 10)
  expect_true(all(sapply(results, function(x) 
    grepl("<strong>Test</strong>", x, fixed = TRUE))))
})