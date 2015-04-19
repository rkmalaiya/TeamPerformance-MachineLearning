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
teamdata.projectwise <- ddply(teamdata, ~ names ~ date, summarise,
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

# Trying Kmeans
for(i in 7:12) {
  
  png(paste0("KmeansCluster_ForCenter_",i,".png"), width = 1390, height = 732)
  par(mfrow= c(3,3))
  
  teamdata.projectwise.km <- kmeans(teamdata.projectwise[, -(1:2)], centers = i, nstart = 3)
  
  teamdata.projectwise_cl <- mutate(teamdata.projectwise, cluster = teamdata.projectwise.km$cluster)
  
  with(teamdata.projectwise_cl, plot(x = project, cluster, xlab="Project Groups", ylab = "Clusters",
                                     main = paste0("Mean Distribution of Clusters(",i," centers)")))
  
  kmCenters <- as.data.frame(teamdata.projectwise.km$centers)
  kmCenters <- mutate(kmCenters,cluster = row.names(kmCenters))
  
  lapply (names(kmCenters)[1:7], function(name) {  
    pie(x = kmCenters[,name], 
        labels = kmCenters$cluster, main = paste0("Work Distribution of ",name," for each Cluster"))  
  })
  dev.off()
}

# Lets assume 9 Centers for Kmeans makes most sense
teamdata.projectwise.km <- kmeans(teamdata.projectwise[, -(1:2)], centers = 9, nstart = 3)
teamdata.projectwise_cl <- mutate(teamdata.projectwise, cluster = teamdata.projectwise.km$cluster)

png("Project-wise_distribution.png", width = 1390, height = 732)
par(mfrow= c(3,3))
lapply(names(teamdata.projectwise_cl)[c(-1,-2,-10)], function(x) {
  plot(teamdata.projectwise_cl[ ,x], teamdata.projectwise_cl$date, col = teamdata.projectwise_cl$project, xlab = x, ylab = "Days", main = paste("Project-wise distribution for",x))
  
}) 
dev.off()

png("Cluster-wise_distribution.png", width = 1390, height = 732)
par(mfrow= c(3,3))
lapply(names(teamdata.projectwise_cl)[c(-1,-2,-10)], function(x) {
  plot(teamdata.projectwise_cl[ ,x], teamdata.projectwise_cl$date, col = teamdata.projectwise_cl$cluster, xlab = x, ylab = "Days", main = paste("Cluster distribution for",x))
}) 
dev.off()

write.csv(teamdata.projectwise_cl, file = "clusters_memberwise.csv")

# Trying HClustering
teamdata.projectwise.dm <- dist(teamdata.projectwise[,-(1:2)])
teamdata.projectwise.hc <- hclust(teamdata.projectwise.dm)

par(mfrow= c(1,1))
png("hcluster.png", width = 4000, height = 1412)
plot(teamdata.projectwise.hc, col = unclass(teamdata.projectwise$project))
dev.off()
