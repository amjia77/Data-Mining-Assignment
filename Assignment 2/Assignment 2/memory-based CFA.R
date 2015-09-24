setwd ("~/UT/Data Mining/Assignment/Assignment 2/Assignment 2")  

###################################################################################
#####      Calculate Similarities                                             #####
###################################################################################

rateData <- read.table('Data for assgt 2/UI data for collaborative filtering.txt')  
# head(rateData)

noUser <- 10
noItem <- 20
outputFile <- "updated UI matrix.txt"


# Create a helper function to calculate the Pearson correlation coefficient between two vectors 
getPearson <- function(x, y) {
  x.bar <- mean(x)
  y.bar <- mean(y)
  this.pearson <- sum((x-x.bar)*(y-y.bar)) / (sqrt(sum((x-x.bar)*(x-x.bar)))*sqrt(sum((y-y.bar)*(y-y.bar))))
  return(this.pearson)
}

# Create a placeholder matrix of similarity user vs. user
similarity <- matrix(NA, noUser, noUser, dimnames=list(1:10, 1:10))


# Fill in the similarity matrix with the Pearson correlation coefficient
for(i in 1:noUser) {
  for(j in 1:noUser) {
    user.u <- rateData[which(rateData$V1==i),]
    user.v <- rateData[which(rateData$V1==j),]
    user.uv <- merge(x=user.u, y=user.v, by="V2")
    
    similarity[i,j] <- getPearson(user.uv$V3.x, user.uv$V3.y)
  }
}

# Back to dataframe and replace NA with zeros
similarity <- as.data.frame(similarity)
similarity[is.na(similarity)] <- 0

##############################################################################
#####               Predict ratings                                      #####
##############################################################################

# Convert the original user-item matrix to 10x20 format with missing values
rate <- matrix(NA, nrow=noUser,ncol=noItem,dimnames=list(1:noUser, 1:noItem))
for(i in 1:nrow(rateData)){
  rate[rateData[i,1],rateData[i,2]] <- rateData[i,3]
}


# Create a placeholder matrix for the prediction
holder <- matrix(NA, nrow=nrow(rate), ncol=ncol(rate), dimnames=list(rownames(rate),colnames(rate)))

# Extract each user's average rating and store it in a vector
meanRating <- rowMeans(rate, na.rm = TRUE)

# Predict rating for missing values and place the prediction into placeholder matrix 
for(i in 1:nrow(rate)) {                  # loop through the user
  for(j in 1:ncol(rate)) {                # loop through the item
    
    # check if the user already rated the item; if not, calculate the prediction rating
    if(is.na(rate[i,j]))
    { 
      holder[i,j] <- meanRating[i] + sum(similarity[i,]*(rate[,j]-meanRating), na.rm=TRUE)/sum(abs(similarity[i,]))
    }
      
    }
}

# Fill out the NA in prediction matrix (i.e., holder) with the actual rating given by original data
for(i in 1:nrow(holder)) {                  # loop through the user
  for(j in 1:ncol(holder)) {                # loop through the item
    
    # cell values with NA means that the user has already rated this item, so replace the NA with actual rating
    if(is.na(holder[i,j]))
    { 
      holder[i,j] <- rate[i,j]
    }
    
  }
}

# Round the outcome rating to 2 decimals 
holder <- round(holder,0)

# Transfer to the initial user-item matrix format
holder.new <- matrix(NA, nrow=noUser*noItem, ncol=ncol(rateData))
holder.new[,1] <- rep(1:noUser, each=noItem)
holder.new[,2] <- rep(1:noItem, noUser)
for(i in 1:nrow(holder.new)){
  holder.new[i,3] <- holder[holder.new[i,1],holder.new[i,2]] 
}

# Back to data frame
holder.new <- as.data.frame(holder.new)
holder <- as.data.frame(holder)

# Store the updated user-item matrix in an output file
# write(t(holder.new), file = outputFile, ncolumns=ncol(holder.new), sep="\t")
write(t(holder), file = outputFile, ncolumns=ncol(holder), sep="\t")