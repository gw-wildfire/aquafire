diff_in_means_bootstrap <- function(sample_data){
  # Step 2: Define the function that calculates the test statistic (difference in means)
  diff_in_means <- function(sample_data, indices) {
    gde_0 <- sample_data %>%
      filter(gde == 0)
    gde_1 <- sample_data %>%
      filter(gde == 1)
    
    nongde_sample <- gde_0[indices, 3]
    gde_sample <- gde_1[indices, 3]
    return(mean(nongde_sample, na.rm = TRUE) - mean(gde_sample, na.rm = TRUE))
  }
  
  # Step 4: Perform the bootstrap procedure
  bootstrap_result <- boot(sample_data, diff_in_means, R = 1000)
  
  # Step 5: Obtain the bootstrap confidence interval and p-value
  confidence_interval_lower <- boot.ci(bootstrap_result, conf = 0.95, type = "norm")$normal[,2] 
  confidence_interval_upper <- boot.ci(bootstrap_result, conf = 0.95, type = "norm")$normal[,3]
  p_value <- boot.pval(bootstrap_result, theta_null = 0)
  
  return(list(confidence_interval_lower, confidence_interval_upper, p_value))
}
