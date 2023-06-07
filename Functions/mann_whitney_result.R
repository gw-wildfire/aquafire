#' Results from Mann-Whitney U Test 
#' Create a dataframe containing Mann-Whitney U Test results for each ecoregion. 
#' @param list_sample_datasets All sample datasets (each created using the stratified_sample() function) from the ecoregions stored in list format. 
#'
#' @return
#' @export
#'
#' @examples
mann_whitney_result <- function(list_sample_datasets){
  result_df <- data.frame(eco_region = character(), 
                          confidence_interval = numeric(),
                          p_value = numeric(), 
                          stringsAsFactors = FALSE)
  for(i in 1:length(list_sample_datasets)){
    mann_whitney_result <- mann_whitney_test(get(list_sample_datasets[[i]]))
    
    confidence_interval_lower <- mann_whitney_result[[1]][1]
    confidence_interval_upper <- mann_whitney_result[[1]][2]
    p_value <- mann_whitney_result[[2]]
    
    new_row <- data.frame(sample = (list_sample_datasets[[i]]),
                          confidence_interval_lower = confidence_interval_lower,
                          confidence_interval_upper = confidence_interval_upper,
                          p_value = p_value)
    result_df <- rbind(result_df, new_row)
  }
  return(result_df)
}