require(plyr)
email_df <- read.delim("email_jan", header = FALSE, sep = "\t", fill = TRUE)
svn_df <- read.delim("svn_jan", header = FALSE, sep = "\t", fill = TRUE)
jira_df <- read.delim("jira_jan", header = FALSE, sep = "\t", fill = TRUE)

colnames(email_df) <- c("name", "date", "project", "email_count")
colnames(svn_df) <- c("name", "date", "project", "svn_count")
colnames(jira_df) <- c("name", "date", "project", "jira_type", "jira_priority", "votes", "watches", "jira_count" )

email_df$project <- as.character(email_df$project)
svn_df$project <- as.character(svn_df$project)
jira_df$project <- as.character(jira_df$project)

email_df$email_count <- gsub("MAIL_CSV", "", email_df$email_count)
email_df$email_count <- as.numeric(email_df$email_count)
email_df$email_count <- email_df$email_count + 1


svn_df$svn_count <- gsub("SVN_LOG", "", svn_df$svn_count)
svn_df$svn_count <- as.numeric(svn_df$svn_count)
svn_df$svn_count <- svn_df$svn_count + 1


jira_df$jira_count <- gsub("ISSUE_LOG", "", jira_df$jira_count)
jira_df$jira_count <- as.numeric(jira_df$jira_count)
jira_df$jira_count <- jira_df$jira_count + 1

jira_df$votes <- gsub("votes", "", jira_df$votes)
jira_df$votes <- as.numeric(jira_df$votes)

jira_df$watches <- gsub("watches", "", jira_df$watches)
jira_df$watches <- as.numeric(jira_df$watches)

jira_df$jira_count <- gsub("ISSUE_LOG", "", jira_df$jira_count)
jira_df$jira_count <- as.numeric(jira_df$jira_count)

svn_df[svn_df$project == 'hadoop-tools', 'project'] <- 'hbase'
svn_df[svn_df$project == 'MISCELLANEOUS' & svn_df$svn_count  >= 2, "project"] <- "hive"
svn_df[svn_df$project == 'MISCELLANEOUS' & svn_df$svn_count  < 2, "svn_count"] <- NA ## "hadoop-yarn-project"
svn_df[svn_df$project == 'hadoop-project', "project"] <- "pig"

# Removing incomplete cases
email_df <- email_df[complete.cases(email_df),]
svn_df <- svn_df[complete.cases(svn_df),]
jira_df <- jira_df[complete.cases(jira_df),]

# convert hbase to miscal

#email_unique_name <- unique(email_df$name)
#svn_unique_name <- unique(svn_df$name)
#jira_unique_name <- unique(jira_df$name)

name_list <- rep(1:10, length.out = 2114)
name_list <- lapply(name_list, function(x) {paste0("t",x)})
name_list <- as.character(name_list)
email_df$name <- as.factor(email_df$name)
levels(email_df$name) <- name_list

name_list <- rep(1:10, length.out = 115)
name_list <- lapply(name_list, function(x) {paste0("t",x)})
name_list <- as.character(name_list)
svn_df$name <- as.factor(svn_df$name)
levels(svn_df$name) <- name_list

name_list <- rep(1:10, length.out = 137)
name_list <- lapply(name_list, function(x) {paste0("t",x)})
name_list <- as.character(name_list)
jira_df$name <- as.factor(jira_df$name)
levels(jira_df$name) <- name_list

# extracting only days
svn_df$date <- as.character(svn_df$date)
svn_df$date <- gsub("-", "", svn_df$date)

svn_df$date <- substring(svn_df$date,7)
email_df$date <- substring(email_df$date,7)
jira_df$date <- substring(jira_df$date,7)

svn_df$date <- as.numeric(svn_df$date)
jira_df$date <- as.numeric(jira_df$date)
email_df$date <- as.numeric(email_df$date)

svn_df <- svn_df[!is.na(svn_df$date), ]
jira_df <- jira_df[!is.na(jira_df$date), ]
email_df <- email_df[!is.na(email_df$date), ]


jira_df$jira_type <- gsub(pattern = "Sub-tasktype", replacement = "Subtasktype", x = jira_df$jira_type)
jira_df$jira_type <- gsub(pattern = "New Featuretype", replacement = "NewFeaturetype", x = jira_df$jira_type)
jira_df$jira_type <- gsub(pattern = "type", replacement = "", x = jira_df$jira_type)

# giving weightage to JIRA Types
jira_types_df <- list(Bug = 1, Improvement = 2, Subtask = 0.5, NewFeature = 4, 
                            Task = 5, Test = 3, Bu = 1, Impr = 5, Wish = 2)

priority_df <- list(Majorpriority = 4, Blockerpriority = 2, Trivialpriority = 3, Minorpriority = 1, 
                              Criticalpriority = 5)

jira_df$jira_type <- gsub(pattern = names(jira_types_df)[1], replacement = jira_types_df[[names(jira_types_df)[1]]], jira_df$jira_type)
jira_df$jira_type <- gsub(pattern = names(jira_types_df)[2], replacement = jira_types_df[[names(jira_types_df)[2]]], jira_df$jira_type)
jira_df$jira_type <- gsub(pattern = names(jira_types_df)[3], replacement = jira_types_df[[names(jira_types_df)[3]]], jira_df$jira_type)
jira_df$jira_type <- gsub(pattern = names(jira_types_df)[4], replacement = jira_types_df[[names(jira_types_df)[4]]], jira_df$jira_type)
jira_df$jira_type <- gsub(pattern = names(jira_types_df)[5], replacement = jira_types_df[[names(jira_types_df)[5]]], jira_df$jira_type)
jira_df$jira_type <- gsub(pattern = names(jira_types_df)[6], replacement = jira_types_df[[names(jira_types_df)[6]]], jira_df$jira_type)
jira_df$jira_type <- gsub(pattern = names(jira_types_df)[7], replacement = jira_types_df[[names(jira_types_df)[7]]], jira_df$jira_type)
jira_df$jira_type <- gsub(pattern = names(jira_types_df)[8], replacement = jira_types_df[[names(jira_types_df)[8]]], jira_df$jira_type)

jira_df$jira_priority <- gsub(pattern = names(priority_df)[1], replacement = priority_df[[names(priority_df)[1]]], jira_df$jira_priority)
jira_df$jira_priority <- gsub(pattern = names(priority_df)[2], replacement = priority_df[[names(priority_df)[2]]], jira_df$jira_priority)
jira_df$jira_priority <- gsub(pattern = names(priority_df)[3], replacement = priority_df[[names(priority_df)[3]]], jira_df$jira_priority)
jira_df$jira_priority <- gsub(pattern = names(priority_df)[4], replacement = priority_df[[names(priority_df)[4]]], jira_df$jira_priority)
jira_df$jira_priority <- gsub(pattern = names(priority_df)[5], replacement = priority_df[[names(priority_df)[5]]], jira_df$jira_priority)

jira_df$jira_type <- as.integer(jira_df$jira_type)
jira_df$jira_priority <- as.integer(jira_df$jira_priority)

#lapply(names(jira_types_df), function(x) {
#  jira_df$jira_type <- gsub(pattern = x, replacement = jira_types_df[[x]], jira_df$jira_type)
  
#})

proj_abr <- list("hadoop-common-project" = "cm", "hadoop-hdfs-project" = "hs", 
                 "hadoop-mapreduce-project" = "mr", "hadoop-yarn-project" = "yn", 
                 "hbase" = "hb", "hive" = "hv", "pig" = "pg"
                 )

svn_df <- mutate(svn_df, name = paste0(proj_abr[project],"_",name))
svn_df$name <- as.factor(svn_df$name)
svn_df$project <- as.factor(svn_df$project)
email_df <- mutate(email_df, name = paste0(proj_abr[project],"_",name))
email_df$name <- as.factor(email_df$name)
jira_df <- mutate(jira_df, name = paste0(proj_abr[project],"_",name))
jira_df$name <- as.factor(jira_df$name)

#Summarizing data

#svn_df <- ddply(svn_df, ~ name ~ project ~ date, summarise, svn_count = sum(svn_count))
email_df <- ddply(email_df, ~ name ~ project ~ date, summarise, email_count = sum(email_count))
jira_df <- ddply(jira_df, ~ name ~ project ~ date, summarise, 
                 watches = sum(watches),
                 votes = sum(votes),
                 jira_count = sum(jira_count),
                 jira_type = max(jira_type),
                 jira_priority =  max(jira_priority)
                 )

all_activity_df <- merge(email_df, svn_df, all=TRUE) #, by = c("name", "date", "project"))
all_activity_df <- merge(all_activity_df, jira_df, all = TRUE, by = c("name", "date", "project"))

sum(complete.cases(all_activity_df))
all_activity_completeCases_df <- all_activity_df[complete.cases(all_activity_df),]

all_activity_df[is.na(all_activity_df)] <- 0

write.csv(all_activity_df, file = "teamdata.csv")
write.csv(all_activity_completeCases_df, file = "teamdata_completeCases.csv")

require("ggplot2")
require("dplyr")

str(svn_df)
par(mfrow= c(3,3))

library(grid)

if(!require(gridExtra)) {
  install.packages("gridExtra")
  require(gridExtra)
}

"
vplayout <- function(x, y) viewport(layout.pos.row = x, layout.pos.col = y)
grid.newpage()
pushViewport(viewport(layout = grid.layout(nrow = 4, ncol = 2)), recording = FALSE)
 
"
grid.newpage()

ggarr <- list()
png("svn_distribution.png", width = 2000, height = 928)
ddply(svn_df, ~ project, function(x){
  g <- ggplot(x) + geom_histogram() + aes(name)
  g <- g + facet_grid(.~project)
  ggarr <<- append(ggarr,list(g))
  0  
})
do.call(grid.arrange,ggarr)
dev.off()

png("email_distribution.png", width = 2000, height = 928)
ggarr <- list()
ddply(email_df, ~ project, function(x){
  g <- ggplot(x) + geom_histogram() + aes(name)
  g <- g + facet_grid(.~project)
  ggarr <<- append(ggarr,list(g))
  0  
})
do.call(grid.arrange,ggarr)
dev.off()

png("jira_distribution.png", width = 2000, height = 928)
ggarr <- list()
ddply(jira_df, ~ project, function(x){
  g <- ggplot(x) + geom_histogram() + aes(name)
  g <- g + facet_grid(.~project)
  ggarr <<- append(ggarr,list(g))
  0  
})
do.call(grid.arrange,ggarr)
dev.off()


"

plots = lapply(1:5, function(.x) qplot(1:10,rnorm(10), main=paste(plot,.x)))
require(gridExtra)
do.call(grid.arrange,  plots)
class(plots)
class(qparr)

"