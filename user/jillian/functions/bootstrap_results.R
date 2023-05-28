bootstrap_results <- function(list_sample_datasets){
  result_df <- data.frame(eco_region = character(), 
                          confidence_interval_lower = numeric(),
                          confidence_interval_upper = numeric(),
                          p_value = numeric(), 
                          stringsAsFactors = FALSE)
  
  for (i in 1:length(list_sample_datasets)){
    bootstrap_result <- diff_in_means_bootstrap(get(list_sample_datasets[[i]]))
    
    new_row <- data.frame(sample = (list_sample_datasets[[i]]),
                          confidence_interval_lower = bootstrap_result[[1]],
                          confidence_interval_upper = bootstrap_result[[2]],
                          p_value = format(bootstrap_result[[3]], scientific = FALSE))
    
    result_df <- rbind(result_df, new_row)
  }
  
  return(result_df)
}