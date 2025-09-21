#' Get Item Fit Statistics
#'
#' @description Returns a data frame of item fit statistics, difficulty parameters, and the
#'   proportion of pro-environmental responses for each REBL item from an eRm Rasch model.
#'   Item fit statistics help assess how well individual items conform to the Rasch model expectations.
#'
#' @param model A fitted eRm Rasch model object (class "eRm")
#' @param df A data frame containing the survey data with REBL items
#' @param rebl_items A character vector of column names corresponding to REBL items in df
#'
#' @returns A data frame containing:
#'   \describe{
#'     \item{rebl_item}{Character. REBL item names}
#'     \item{prop_peb}{Numeric. Proportion of pro-environmental responses (0-1)}
#'     \item{i.fit}{Numeric. Infit statistics from eRm::itemfit()}
#'     \item{i.outfitMSQ}{Numeric. Outfit mean square statistics}
#'     \item{eta}{Numeric. Item difficulty parameters}
#'     \item{eta_se}{Numeric. Standard errors of difficulty parameters}
#'   }
#' @seealso [get_rasch_model()], [get_person_fits()]
#' @importFrom dplyr select any_of mutate full_join %>%
#' @importFrom tibble rownames_to_column
#' @importFrom eRm person.parameter itemfit
#' @importFrom stringr str_remove
#' @importFrom purrr map
#' @importFrom stats setNames
#' @export
#'
#' @examples
#' \dontrun{
#'   # Create sample REBL data
#'   df <- data.frame(
#'     id = 1:100,
#'     rebl_1 = sample(0:1, 100, replace = TRUE),
#'     rebl_2 = sample(0:1, 100, replace = TRUE),
#'     rebl_3 = sample(0:1, 100, replace = TRUE)
#'   )
#'   rebl_items <- c("rebl_1", "rebl_2", "rebl_3")
#'
#'   # Fit Rasch model
#'   model <- get_rasch_model(df, "id", rebl_items, type = "cml")
#'
#'   # Get item fit statistics
#'   item_fits <- get_item_fits(model, df, rebl_items)
#'   print(item_fits)
#' }
get_item_fits <- function(model, df, rebl_items) {
  assertthat::assert_that(
    'eRm' %in% class(model),
    msg = paste('get_item_fit() function is only available for CML models currently.')
  )
  assertthat::assert_that(
    'data.frame' %in% class(df),
    msg = paste(df, 'must be a data.frame')
  )
  assertthat::assert_that(
    class(rebl_items) == 'character' && length(rebl_items) > 1,
    msg = paste(rebl_items, 'must be a character vector of length > 1')
  )

  # Get DF of proportion PEB for REBL items
  prop_peb_df <- df %>%
    dplyr::select(dplyr::any_of(rebl_items)) %>%
    colMeans(na.rm = TRUE) %>%
    as.data.frame() %>%
    stats::setNames('prop_peb') %>%
    tibble::rownames_to_column(var = 'rebl_item')

  # Get DF of most item fit statistics
  item_fit_df <- model %>%
    eRm::person.parameter() %>%
    eRm::itemfit() %>%
    .[-3] %>%
    purrr::map(as.vector) %>%
    as.data.frame() %>%
    dplyr::mutate(rebl_item = prop_peb_df$rebl_item)

  # Get DF of item difficulties.
  # One less item fit than items because they are relative to first
  item_difficulty_df <- data.frame(eta = model$etapar,
                                   eta_se = model$se.eta) %>%
    tibble::rownames_to_column(var = 'rebl_item')
    # dplyr::mutate(rebl_item = stringr::str_remove(rebl_item, '_'))

  # Join all three DFs together as result
  result <- prop_peb_df %>%
    dplyr::full_join(item_fit_df, by = 'rebl_item') %>%
    dplyr::full_join(item_difficulty_df, by = 'rebl_item')

  return(result)
}
