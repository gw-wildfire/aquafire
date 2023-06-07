#' Mann Whitney Test
#'
#' @param sample_data Sample data created using the stratified_sample() function 
#'
#' @return Returns a lost containing the confidence interval and p-value for the test for that ecoregion. 
#' @export
#'
#' @examples
mann_whitney_test <- function(sample_data){
  # Perform mann whitney test 
  test_result <- wilcox.test(value ~ gde, data = sample_data, paired = FALSE, conf.int = TRUE, exact = FALSE)
  
  # Extract values 
  confidence_interval <- test_result[[8]]
  
  # confidence_interval_upper 
  p_value <- test_result[[3]]
  
  return(list(confidence_interval, p_value))
}