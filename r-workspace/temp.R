x <- data.frame(a="a1", b="b1")
y <- data.frame(a=c("a1", "x3"), y=c("a1", "y3"))
merge(e1,s1, all = TRUE)



x <- sample_n(email_df, size = 10)
y <- sample_n(svn_df, size = 10)


z <- merge(email_df[4550:5000,], svn_df[4500:5000,], all=TRUE)
z1 <- merge(email_df[email_df$name == "hive_t_5" & email_df$date == 16,],
            svn_df[svn_df$name == "hive_t_5" & svn_df$date == 16,], all=TRUE)

e1 <- email_df[email_df$name == "hive_t_5" & email_df$date == 16,]
s1 <- svn_df[svn_df$name == "hive_t_5" & svn_df$date == 16,]

s1 <- ddply(s1, ~ name ~ project ~ date, summarise, svn_count = sum(svn_count))
