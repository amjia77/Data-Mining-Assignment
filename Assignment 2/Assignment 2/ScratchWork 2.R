user.1 <- rateData[which(rateData$V1==1),];
user.2 <- rateData[which(rateData$V1==2),];
user.12 <- merge(x=user.1, y=user.2, by="V2")

getCosine <- function(x, y) {
  x.bar <- mean(x);
  y.bar <- mean(y);
  this.cosine <- sum((x-x.bar)*(y-y.bar)) / (sqrt(sum((x-x.bar)*(x-x.bar)))*sqrt(sum((y-y.bar)*(y-y.bar))))
  return(this.cosine)
}
  
sim.12 <- getCosine(user.12$V3.x, user.12$V3.y)

rep(1:4,2)
rep(1:4, each = 2)



#############################################################################
########               Ideas for part 2                           ###########
#############################################################################

# Create a placeholder matrix of prediction
predict.0 <- matrix(NA, nrow=noUser*noItem, ncol=ncol(rateData))
predict.0[,1] <- rep(1:noUser, each=noItem)
predict.0[,2] <- rep(1:noItem, noUser)

# Import users' rating history to the predict matrix
predict <- merge(x = rateData, y = predict.0, by = c("V1","V2"), all.y = TRUE)

# Create a helper function to calculate the predicted score
getScore <- function(x, y, sim)
{
  x.bar <- mean(x)
  y.bar <- mean(y)
  this.score <- x.bar + sum((y-y.bar)*sim)/sum(abs(sim))
  return(this.score)
}




# ...(code here)...    # replace the NA in third column with correspondent value in the fourth column
predict <- predict[,-4]   # drop un-wanted column

write(t(predict), file = outputFile, ncolumns=ncol(predict))

###############################################################################


r11 <- meanRating[1] + sum(similarity[1,]*(rate[,1]-meanRating), na.rm=TRUE)/sum(abs(similarity[1,]))
  
