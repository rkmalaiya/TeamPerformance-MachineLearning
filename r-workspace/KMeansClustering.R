teamdata <- read.csv("teamdata.csv")
teamdata_completeCases <- read.csv("teamdata_completeCases.csv")

## Find patterns of activity of each group

# grouping data based on project

if(!require(caTools)) {
  install.packages("caTools")
  require(caTools)
}
if(!require(EMCluster)) {
  install.packages("EMCluster")
  require(EMCluster)
}
if(!require(dplyr)) {
  install.packages("dplyr")
  require(dplyr)
}
if(!require(plyr)) {
  install.packages("plyr")
  require(plyr)
}
if(!require(ggplot2)) {
  install.packages("ggplot2")
  require(ggplot2)
}

# Getting only Project-wise data
teamdata.projectwise <- ddply(teamdata, ~ name ~ date, summarise,
                              jira_count = sum(jira_count),
                              svn_count = sum(svn_count),
                              email_count = sum(email_count),
                              jira_type = max(jira_type),
                              jira_priority = max(jira_priority),
                              votes = sum(votes),
                              watches = sum(watches)
                              )

teamdata.projectwise.dm <- dist(teamdata.projectwise[,-(1:2)])
teamdata.projectwise.hc <- hclust(teamdata.projectwise.dm)

par(mfrow= c(1,1))
plot(teamdata.projectwise.hc, col = unclass(teamdata.projectwise$project))

teamdata.projectwise.km = kmeans(teamdata.projectwise[, -(1:2)], centers = 4, nstart = 3)



modelName = "EEE"
data = teamdata.projectwise[, -(1:2)]
z = unmap(teamdata.projectwise[, -(1:2)])
msEst <- mstep(modelName, data, z)
names(msEst)
modelName = msEst$modelName
parameters = msEst$parameters
em(modelName, data, parameters)






ret <- init.EM(teamdata.projectwise[, -(1:2)], nclass = 2)
teamdata.projectwise.em = assign.class(teamdata.projectwise[, -(1:2)], ret, return.all = FALSE)
#teamdata.projectwise.em = emcluster(x = teamdata.projectwise[, -(1:2)], centers = 4, nstart = 3)

str(teamdata.projectwise.km$cluster)

par(mfrow= c(1,1))
plot(teamdata.projectwise.km$cluster, pch = 19, ylab = "Cluster Center", xlab = "")

teamdata.projectwise <- mutate(teamdata.projectwise, cluster = teamdata.projectwise.km$cluster)

#png("datapoints_distribution.png", width = 1200, height = 786)
plot(teamdata.projectwise[, c(-1, -2, -10)], main = "Data-point distribution")
#dev.off()


par(mfrow= c(3,3))
lapply(names(teamdata.projectwise)[c(-1,-2,-10)], function(x) {
  plot(teamdata.projectwise[ ,x], teamdata.projectwise$date, col = teamdata.projectwise$project, xlab = x, ylab = "Days", main = paste("Project-wise distribution for",x))
  
}) 


par(mfrow= c(3,3))
lapply(names(teamdata.projectwise)[c(-1,-2,-10)], function(x) {
  plot(teamdata.projectwise[ ,x], teamdata.projectwise$date, col = teamdata.projectwise$cluster, xlab = x, ylab = "Days", main = paste("Cluster distribution for",x))
}) 

par(mfrow= c(1,1))
with(teamdata.projectwise, plot(x = project, cluster, xlab="Project Groups", ylab = "Clusters"))

write.csv(teamdata.projectwise, file = "clusters.csv")



