#' Example REBL Survey Data
#'
#' @description A processed dataset containing simulated responses to the REBL survey from 100
#'   participants. This dataset contains numeric (0/1) coded responses for 24
#'   REBL items measuring pro-environmental behaviors across four domains: food,
#'   home, packaging, social, and water.
#'
#' @format A data frame with 100 rows and 25 variables:
#'   \describe{
#'     \item{respondent_id}{Character. Unique participant identifier (p1-p100)}
#'     \item{foodLocal}{Numeric. Eating locally grown food (0=No, 1=Yes)}
#'     \item{foodLunchNoMeat}{Numeric. Eating lunch without meat (0=No, 1=Yes)}
#'     \item{foodMeat}{Numeric. Eating meat regularly (0=No, 1=Yes)}
#'     \item{foodOatMilk}{Numeric. Drinking oat milk (0=No, 1=Yes)}
#'     \item{foodTofu}{Numeric. Eating tofu (0=No, 1=Yes)}
#'     \item{foodVegan}{Numeric. Following vegan diet (0=No, 1=Yes)}
#'     \item{homeClothesCold}{Numeric. Washing clothes in cold water (0=No, 1=Yes)}
#'     \item{homeClothesHang}{Numeric. Hanging clothes to dry (0=No, 1=Yes)}
#'     \item{homeLightsOff}{Numeric. Turning lights off when leaving room (0=No, 1=Yes)}
#'     \item{packCarriedUtensils}{Numeric. Carrying reusable utensils (0=No, 1=Yes)}
#'     \item{packCompost}{Numeric. Composting organic waste (0=No, 1=Yes)}
#'     \item{packContainerToRestaurant}{Numeric. Bringing container to restaurant (0=No, 1=Yes)}
#'     \item{packPickedUpLitter}{Numeric. Picking up litter (0=No, 1=Yes)}
#'     \item{packPullRecycleFromTrash}{Numeric. Pulling recyclables from trash (0=No, 1=Yes)}
#'     \item{packRags}{Numeric. Using rags instead of paper towels (0=No, 1=Yes)}
#'     \item{packReusableMug}{Numeric. Using reusable mug (0=No, 1=Yes)}
#'     \item{packReusedPaperPlasticBags}{Numeric. Reusing paper/plastic bags (0=No, 1=Yes)}
#'     \item{purchBuyNothing}{Numeric. Participating in buy nothing groups (0=No, 1=Yes)}
#'     \item{socialDocumentary}{Numeric. Watching environmental documentaries (0=No, 1=Yes)}
#'     \item{socialGroup}{Numeric. Participating in environmental groups (0=No, 1=Yes)}
#'     \item{socialRead}{Numeric. Reading about environmental issues (0=No, 1=Yes)}
#'     \item{socialSupportive}{Numeric. Being supportive of environmental causes (0=No, 1=Yes)}
#'     \item{waterShowerStop}{Numeric. Stopping water while showering (0=No, 1=Yes)}
#'     \item{waterTeethStop}{Numeric. Stopping water while brushing teeth (0=No, 1=Yes)}
#'   }
#'
#' @details This dataset is the processed version of \code{raw_example}, where
#'   character responses ("Yes"/"No") have been converted to numeric values (1/0).
#'   The data can be used for Rasch modeling and other psychometric analyses of
#'   pro-environmental behavior patterns.
#'
#' @seealso \code{\link{raw_example}} for the original character-coded data,
#'   \code{\link{get_rasch_model}} for fitting Rasch models to this data
#'
#' @examples
#' # Load the data
#' data(example)
#'
#' # View structure
#' str(example)
#'
#' # Summary of pro-environmental behavior frequencies
#' colSums(example[, -1])  # Exclude respondent_id column
#'
"example"
