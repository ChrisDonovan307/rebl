test_that("get_item_fits works with eRm models", {
  # Skip if eRm not available
  skip_if_not_installed("eRm")

  # Create test data
  set.seed(123)
  test_df <- data.frame(
    id = as.character(1:20),
    rebl_1 = sample(c(0, 1), 20, replace = TRUE),
    rebl_2 = sample(c(0, 1), 20, replace = TRUE),
    rebl_3 = sample(c(0, 1), 20, replace = TRUE),
    rebl_4 = sample(c(0, 1), 20, replace = TRUE),
    rebl_5 = sample(c(0, 1), 20, replace = TRUE)
  )

  rebl_items <- paste0('rebl_', 1:5)

  # Create eRm model
  model <- get_rasch_model(test_df, "id", rebl_items, type = 'cml')

  # Get item fits
  item_fits <- get_item_fits(model, test_df, rebl_items)

  # Check structure
  expect_true(is.data.frame(item_fits))
  expect_true("rebl_item" %in% names(item_fits))
  expect_true("prop_peb" %in% names(item_fits))
  expect_equal(nrow(item_fits), length(rebl_items))

  # Check that all REBL items are included
  expect_setequal(item_fits$rebl_item, rebl_items)

  # Check that proportions are between 0 and 1
  expect_true(all(item_fits$prop_peb >= 0 & item_fits$prop_peb <= 1))

  # Should have item fit statistics
  fit_cols <- names(item_fits)
  expect_true(any(grepl("fit", fit_cols, ignore.case = TRUE)))

  # Should have difficulty parameters
  expect_true("eta" %in% names(item_fits))
  expect_true("eta_se" %in% names(item_fits))
})

test_that("get_item_fits validates input parameters", {
  # Create test data
  set.seed(42)
  test_df <- data.frame(
    id = as.character(1:10),
    rebl_1 = sample(c(0, 1), 10, replace = TRUE),
    rebl_2 = sample(c(0, 1), 10, replace = TRUE)
  )

  rebl_items <- c("rebl_1", "rebl_2")
  model <- get_rasch_model(test_df, "id", rebl_items, type = 'cml')

  # Test with non-eRm model
  fake_model <- list(class = "fake")
  class(fake_model) <- "fake"
  expect_error(
    get_item_fits(fake_model, test_df, rebl_items),
    "get_item_fit\\(\\) function is only available for CML models currently"
  )

  # Test with non-data.frame
  expect_error(
    get_item_fits(model, "not_a_df", rebl_items),
    "must be a data.frame"
  )

  # Test with invalid rebl_items
  expect_error(
    get_item_fits(model, test_df, "single_item"),
    "must be a character vector of length > 1"
  )
})

test_that("get_item_fits handles missing data correctly", {
  # Skip if eRm not available
  skip_if_not_installed("eRm")

  # Create test data with some missing values
  set.seed(42)
  test_df <- data.frame(
    id = as.character(1:15),
    rebl_1 = sample(c(0, 1, NA), 15, replace = TRUE),
    rebl_2 = sample(c(0, 1, NA), 15, replace = TRUE),
    rebl_3 = sample(c(0, 1), 15, replace = TRUE)
  )

  rebl_items <- c("rebl_1", "rebl_2", "rebl_3")

  # Create model (eRm should handle missing data)
  model <- get_rasch_model(test_df, "id", rebl_items, type = 'cml')

  # Get item fits
  item_fits <- get_item_fits(model, test_df, rebl_items)

  # Should still return valid results
  expect_true(is.data.frame(item_fits))
  expect_equal(nrow(item_fits), length(rebl_items))

  # Proportions should still be valid (colMeans with na.rm = TRUE)
  expect_true(all(item_fits$prop_peb >= 0 & item_fits$prop_peb <= 1, na.rm = TRUE))
})

test_that("get_item_fits returns expected column structure", {
  # Skip if eRm not available
  skip_if_not_installed("eRm")

  # Create simple test data
  set.seed(101)
  test_df <- data.frame(
    id = as.character(1:12),
    item_a = sample(c(0, 1), 12, replace = TRUE),
    item_b = sample(c(0, 1), 12, replace = TRUE),
    item_c = sample(c(0, 1), 12, replace = TRUE)
  )

  rebl_items <- c("item_a", "item_b", "item_c")
  model <- get_rasch_model(test_df, "id", rebl_items, type = 'cml')

  # Get item fits
  result <- get_item_fits(model, test_df, rebl_items)

  # Check expected columns exist
  expected_cols <- c("rebl_item", "prop_peb")
  expect_true(all(expected_cols %in% names(result)))

  # Check that result has correct number of rows
  expect_equal(nrow(result), length(rebl_items))

  # Check that no results are completely missing
  expect_false(all(is.na(result$prop_peb)))
})

test_that("get_item_fits handles single response patterns", {
  # Skip if eRm not available
  skip_if_not_installed("eRm")

  # Create data with more varied response patterns
  test_df <- data.frame(
    id = as.character(1:8),
    rebl_1 = c(1, 0, 1, 0, 1, 1, 0, 0),
    rebl_2 = c(0, 1, 1, 0, 0, 1, 1, 0),
    rebl_3 = c(1, 1, 0, 1, 0, 0, 1, 1)
  )

  rebl_items <- c("rebl_1", "rebl_2", "rebl_3")
  model <- get_rasch_model(test_df, "id", rebl_items, type = 'cml')

  # Should not error
  expect_no_error({
    result <- get_item_fits(model, test_df, rebl_items)
  })

  # Should return meaningful results
  result <- get_item_fits(model, test_df, rebl_items)
  expect_true(is.data.frame(result))
  expect_equal(nrow(result), 3)
})
