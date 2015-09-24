DF <- data.frame(
  x=1:10,
  y=10:1,
  z=rep(5,10),
  a=11:20
)
drops <- c("x","z")
DF[,!(names(DF) %in% drops)]

pangram <- "The|quick brown|fox jumps|over|the lazy dog"
length(unlist(strsplit(pangram, '|', fixed=TRUE)))

df <- data.frame(ID=11:13, FOO=c('a|b','b|c','x|y'))
strsplit(as.character(df$FOO),'|',fixed=TRUE))