# Create data directory
if (!file.exists("data")) dir.create("data")

# Download data from the internet
fileUrl <- "https://data.baltimorecity.gov/api/views/dz54-2aru/rows.csv?accessType=DOWNLOAD"
# method = curl is necessary for Mac when https
download.file(fileUrl, destfile = "./data/cameras.csv", method = "curl") 
list.files("./data")

dateDownloaded <- date()

# Reading local files
filePath <- "./data/cameras.csv"
cameraData <- read.table(filePath, sep = ",", header = TRUE)
cameraData <- read.csv(filePath)

head(cameraData)

# Reading excel files
install.packages("xlsx")  ## Having issues with the rJava package
library(xlsx)

excelTestData <- read.xlsx("./data/test_read_excel.xlsx")


# Reading XML files
library(XML)
fileUrl <- "http://w3schools.com/xml/simple.xml"
doc <- xmlTreeParse(fileUrl, useInternalNodes = TRUE) # Important to use useInternalNodes = TRUE for xpathSApply to work
rootNode <- xmlRoot(doc)

xmlName(rootNode)

names(rootNode)

rootNode[[1]]

xmlSApply(rootNode, FUN = xmlValue)

## Check out the XPath
xpathSApply(rootNode, "//name", fun = xmlValue)

# Reading JSON
library(jsonlite)

jsonData <- fromJSON("https://api.github.com/users/jtleek/repos")
names(jsonData)
names(jsonData$owner)
jsonData$owner$login

# From data fram to JSON and the other way around
library(datasets)
myJson <- toJSON(iris, pretty = TRUE)
cat(myJson)
iris2 <- fromJSON(myJson)
head(iris2)

#  