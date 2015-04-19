readNClean <- function() {
  email_df <- read.delim("email_jan", header = FALSE, sep = "\t", fill = TRUE)
  svn_df <- read.delim("svn_jan", header = FALSE, sep = "\t", fill = TRUE)
  jira_df <- read.delim("jira_jan", header = FALSE, sep = "\t", fill = TRUE)
  
  colnames(email_df) <- c("name", "date", "project", "mail_count")
  colnames(svn_df) <- c("name", "date", "project", "svn_count")
  colnames(jira_df) <- c("name", "date", "project", "jira_type", "jira_priority", "votes", "watches", "jira_count" )
  
  email_df$project <- as.character(email_df$project)
  svn_df$project <- as.character(svn_df$project)
  jira_df$project <- as.character(jira_df$project)
  
  email_df$mail_count <- gsub("MAIL_CSV", "", email_df$mail_count)
  email_df$mail_count <- as.numeric(email_df$mail_count)
  
  svn_df$svn_count <- gsub("SVN_LOG", "", svn_df$svn_count)
  svn_df$svn_count <- as.numeric(svn_df$svn_count)
  
  jira_df$jira_count <- gsub("ISSUE_LOG", "", jira_df$jira_count)
  jira_df$jira_count <- as.numeric(jira_df$jira_count)
  jira_df$jira_count <- jira_df$jira_count + 1
  
  jira_df$votes <- gsub("votes", "", jira_df$votes)
  jira_df$votes <- as.numeric(jira_df$votes)
  
  jira_df$watches <- gsub("watches", "", jira_df$watches)
  jira_df$watches <- as.numeric(jira_df$watches)
  
  jira_df$jira_count <- gsub("ISSUE_LOG", "", jira_df$jira_count)
  jira_df$jira_count <- as.numeric(jira_df$jira_count)
  
}