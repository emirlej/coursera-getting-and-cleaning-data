csvFileUrl <- "https://d396qusza40orc.cloudfront.net/getdata%2Fdata%2Fss06hid.csv"
csvFile <- "2006_idaho_housing_survey.csv"

# Download only if not already 
if (!file.exists(file.path("data", csvFile))) {
download.file(csvFileUrl, destfile = file.path("data", csvFile))
}


df <- read.csv(file.path("data", csvFile))

head(df)
str(df$VAL)
unique(df$VAL)

# Question 1 : How many properties are worth $1,000,000 or more?
nrow((df[!is.na(df$VAL) & df$VAL >= 24, ]))

str(df$FES)
unique(df$FES)

# Question 2
library(xlsx)
xlsxFileUrl <- "https://d396qusza40orc.cloudfront.net/getdata%2Fdata%2FDATA.gov_NGAP.xlsx"
xlsxFile <- "natural_gas_aquisition_prog.xlsx"
download.file(xlsxFileUrl, destfile = file.path("data", xlsxFile), mode = "wb") # Mode important to read it using read.xlsx

# Read rows 18-23 and columns 7-15 into R and assign the result to a variable 
rows <- 18:23
cols <- 7:15

dat <- read.xlsx(file.path("data", xlsxFile), sheetIndex = 1, rowIndex = rows, colIndex = cols, header = TRUE)
head(dat)

sum(dat$Zip * dat$Ext, na.rm = T)

# Question 3
library(XML)
# Needed to change https to http to work
fileUrl <- "http://d396qusza40orc.cloudfront.net/getdata%2Fdata%2Frestaurants.xml"

# Read document
doc <- xmlTreeParse(fileUrl, useInternalNodes = TRUE)

# Find root node
rootNode <- xmlRoot(doc)

# Number of zipcodes with a specific value
sum(xpathSApply(rootNode, "//zipcode", fun = xmlValue) == "21231")

# Question 5
library(data.table)
fileUrl <- "https://d396qusza40orc.cloudfront.net/getdata%2Fdata%2Fss06pid.csv"
csvFile <- "us_communities.csv"
download.file(fileUrl, destfile = file.path("data", csvFile))

DT <- fread(file.path("data", csvFile))
tables()

head(DT)


system.time(DT[, mean(pwgtp15), by = SEX])
system.time(sapply(split(DT$pwgtp15, DT$SEX), mean))
system.time(mean(DT$pwgtp15, by = DT$SEX))
system.time({
    mean(DT[DT$SEX == 1,]$pwgtp15) 
    mean(DT[DT$SEX == 2,]$pwgtp15)})

