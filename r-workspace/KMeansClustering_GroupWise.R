teamdata <- read.csv("teamdata.csv")
teamdata_completeCases <- read.csv("teamdata_completeCases.csv")

## Find patterns of activity of each group

# grouping data based on project

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
teamdata.projectwise <- ddply(teamdata, ~ project ~ date, summarise,
                              jira_count = sum(jira_count),
                              svn_count = sum(svn_count),
                              email_count = sum(email_count),
                              jira_type = max(jira_type),
                              jira_priority = max(jira_priority),
                              votes = sum(votes),
                              watches = sum(watches)
)

png("datapoints_distribution.png", width = 1200, height = 786)
plot(teamdata.projectwise[, c(-1, -2, -10)], main = "Data-point distribution")
dev.off()


# Trying HClustering
teamdata.projectwise.dm <- dist(teamdata.projectwise[,-(1:2)])
teamdata.projectwise.hc <- hclust(teamdata.projectwise.dm)

par(mfrow= c(1,1))
png("hcluster.png", width = 4000, height = 1412)
plot(teamdata.projectwise.hc, col = unclass(teamdata.projectwise$project))
dev.off()


# Trying Kmeans

png(paste0("KmeansCluster_WithCenters.png"), width = 1756, height = 783)
par(mfrow= c(4,2))
for(i in 6:12) {
teamdata.projectwise.km = kmeans(teamdata.projectwise[, -(1:2)], centers = i, nstart = 3)

#par(mfrow= c(1,1))
#png(paste0("KmeansCluster_WithCenters",i,".png"), width = 2000, height = 928)
#plot(teamdata.projectwise.km$cluster, pch = 19, ylab = paste0("Cluster number (",i," Centers)"),
#     main = "Kmeans Cluster Distribution", xlab = "Data Instances")
#dev.off()

teamdata.projectwise <- mutate(teamdata.projectwise, cluster = teamdata.projectwise.km$cluster)

#par(mfrow= c(1,1))
#png(paste0("KmeansClusterMeanDistribution_WithCenters",i,".png"), width = 2000, height = 928)
with(teamdata.projectwise, plot(x = project, cluster, xlab="Project Groups", ylab = "Clusters",
     main = "Mean Distribution of Clusters"))
#dev.off()

}
dev.off()


par(mfrow= c(3,3))
lapply(names(teamdata.projectwise)[c(-1,-2,-10)], function(x) {
  plot(teamdata.projectwise[ ,x], teamdata.projectwise$date, col = teamdata.projectwise$project, xlab = x, ylab = "Days", main = paste("Project-wise distribution for",x))
  
}) 


par(mfrow= c(3,3))
lapply(names(teamdata.projectwise)[c(-1,-2,-10)], function(x) {
  plot(teamdata.projectwise[ ,x], teamdata.projectwise$date, col = teamdata.projectwise$cluster, xlab = x, ylab = "Days", main = paste("Cluster distribution for",x))
}) 


write.csv(teamdata.projectwise, file = "clusters.csv")


