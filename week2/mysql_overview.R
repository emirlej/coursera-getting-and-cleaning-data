library(DBI)

# Example found on: https://blog.rstudio.org/2015/01/09/rmysql-0-1-0/

#con <- dbConnect(RMySQL::MySQL(),
#  username = "public",
#  password = "F60RUsyiG579PeKdCH",
#  host = "173.194.227.144",
#  port = 3306,
#  dbname = "datasets"
#)

# Connecting to the Genome database at UCSC
ucscDb <- dbConnect(RMySQL::MySQL(),
                    user = "genome",
                    host = "genome-mysql.cse.ucsc.edu")

result <- dbGetQuery(ucscDb, "show databases;")
dbDisconnect(ucscDb)

result

# Connecting to hg19 db and listing tables
hg19 <- dbConnect(RMySQL::MySQL(), user = "genome", db = "hg19",
                  host = "genome-mysql.cse.ucsc.edu")
allTables <- dbListTables(hg19)

length(allTables)
allTables[1:5]

dbListFields(hg19, "affyU133Plus2")


# Number of rows in table
dbGetQuery(hg19, "SELECT COUNT(*) FROM affyU133Plus2 ")


affyData <- dbReadTable(hg19, "affyU133Plus2")
head(affyData)
str(affyData)

# Select a specific subset
query <- dbSendQuery(hg19, 
                     "SELECT * FROM affyU133Plus2 
                      WHERE misMatches BETWEEN 1 AND 3 "
                      )
affyMis <- fetch(query)
quantile(affyMis$misMatches)

# Fetch only the first ten rows
affyMisSmall <- fetch(query, n = 10)
dim(affyMisSmall)

# When finished with query, clear it
dbClearResult(query)

# Disconnect from the database
dbDisconnect(hg19)
