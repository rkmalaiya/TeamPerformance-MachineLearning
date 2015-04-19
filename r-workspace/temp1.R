for(i in 7:12) {
  
  png(paste0("KmeansCluster_ForCenter_",i,".png"), width = 1390, height = 732)
  par(mfrow= c(3,3))
  
  teamdata.projectwise.km <- kmeans(teamdata.projectwise[, -(1:2)], centers = i, nstart = 3)
  
  teamdata.projectwise_cl <- mutate(teamdata.projectwise, cluster = teamdata.projectwise.km$cluster)
  
  with(teamdata.projectwise_cl, plot(x = project, cluster, xlab="Project Groups", ylab = "Clusters",
                                     main = paste0("Mean Distribution of Clusters(",i," centers)")))
  
  kmCenters <- as.data.frame(teamdata.projectwise.km$centers)
  kmCenters$cluster <- round(kmCenters$cluster)
  
  kmCenters <- ddply(kmCenters, ~cluster, colMeans)
  
  lapply (names(kmCenters)[1:7], function(name) {  
    pie(x = kmCenters[,name], 
        labels = kmCenters$cluster, main = paste0("Work Distribution of ",name," for each Cluster"))  
  })
  dev.off()
}
