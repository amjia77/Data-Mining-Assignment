setwd ("~/UT/Data Mining/Assignment/Assignment 1/Assignment 1")             

library(xlsx)   

data <- read.xlsx("appmon_1.xls", sheetIndex=1, header=TRUE)           ## Read data


data$mouseclicks[data$mouseclicks > 200] <- 0      ## 1. Set mouseclicks[i] to 0 if it is an outlier (Value > 200) 
data$keystrokes[data$keystrokess > 100] <- 0       ## 2. Set keystrokes[i] to 0 if it is an outlier (Value > 100) 

# options("digits.secs"=0)     ## Display actual_time in full precision
data$actual_time <- data$mSec.from.start/1e3 + ISOdatetime(2012,6,21,8,7,50)  ## 3. Extract the actual time at row i 


## 4. Extract a Window Switch feature
for(i in 2:nrow(data)) {
  if((data[i, "focus_app_name"] != data[i-1, "focus_app_name"]) & (data[i, "focus_app_title"] != data[i-1, "focus_app_title"])) {
    data[i,"window.switch"] <- 1
  }
  else 
    data[i, "window.switch"] <- 0
}
data[1, "window.switch"] <- 0


## 5. Extract the number of opened windows
#  ##This statement DOES NOT work## data$num_of_opened_windows <- length(unlist(strsplit(as.character(data$opened_windows), "|", fixed=TRUE)))-1
for(i in 1:nrow(data)) {
  data[i,"cat_of_opened_windows"] <- length(unlist(strsplit(as.character(data[i,"opened_windows"]), "|", fixed=TRUE)))-1
}


## 6. Extract a categorization of mousemoves
cat <- factor(c("No Move", "Slow", "Moderate", "Fast"))
for(i in 1:nrow(data)) {
  if(data[i, "mousemoves"] == 0) {
   data[i,"cat_of_mousemoves"] <- cat[1]
  } else
  if(0 < data[i, "mousemoves"] & data[i, "mousemoves"] < 36) {
    data[i,"cat_of_mousemoves"] <- cat[2]
  } else
  if (36 <= data[i, "mousemoves"] & data[i, "mousemoves"] < 55) {
    data[i,"cat_of_mousemoves"] <- cat[3]
  } else
  if (55 <= data[i, "mousemoves"]) {
    data[i,"cat_of_mousemoves"] <- cat[4]
  }
}


## 7. Unused features from the original set shall be deleted.
drops <- c("last_input_ms", "cpu_intensive_processes", "pc_locked_or_screensaver", "mousewheelmoves")
data1 <- data[,!(names(data) %in% drops)]


# write.xlsx(x = data1, file = "appmon_1_out.xls")   ## 8. Save the new data in appmon_1_out.xls

write.csv(data1, file = "appmon_1_out_csv.csv")