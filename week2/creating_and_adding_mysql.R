library(DBI)

myPassword <- readline(prompt = "Enter MySQL password: ")

# Connect to my local database server
mydb <- dbConnect(RMySQL::MySQL(), user = "root", password = myPassword,
                  host = "localhost")

# Look at which databases are found on the server
allDatabases <- dbGetQuery(mydb, "SHOW DATABASES;")

allDatabases


# Create a new database
dbSendQuery(mydb, "CREATE DATABASE bookstore;")

dbSendQuery(mydb, "USE bookstore;")

# Connect to the database we just created
mydb = dbConnect(RMySQL::MySQL(), user = "root", password = myPassword, host = "localhost",
                 dbname = "bookstore")

# Remove the table if it already exists
dbSendQuery(mydb, "DROP TABLE IF EXISTS books, authors;")

# Create tables is bookstore DB
dbSendQuery(mydb, 
            " CREATE TABLE books (book_id INT, title VARCHAR(50), author VARCHAR(50));")

# Show tables in bookstore
dbListTables(mydb)

# Considering our bookstore a bit more, we realize that we need to add 
# a few more columns for data elements: publisher, publication year, 
# ISBN number, genre (e.g., novel, poetry, drama), description of book, etc. 

# We also realize that we want MySQL to automatically assign a number 
# to the book_id column so that we don't have to bother creating one for
# each row or worry about duplicates. 

# Additionally, we've decided to change the author column from 
# the actual author's name to an identification number that we'll
#  join to a separate table containing a list of authors. 

# This will reduce typing, and will make sorting and searching easier,
# as the data will be uniform. 

# To make these alterations to the table that we've already created, 
# enter the following SQL command through R :

dbSendQuery(mydb, "ALTER TABLE books
CHANGE COLUMN book_id book_id INT AUTO_INCREMENT PRIMARY KEY,
CHANGE COLUMN author author_id INT,
ADD COLUMN description TEXT,
ADD COLUMN genre ENUM('novel','poetry','drama', 'tutorials', 'text', 'other'),
ADD COLUMN publisher_id INT,
ADD COLUMN pub_year VARCHAR(4),
ADD COLUMN isbn VARCHAR(20);")

# Now, Before moving on to adding data to our books table, 
# let's quickly set up the authors table.

dbSendQuery(mydb, "CREATE TABLE authors
(author_id INT AUTO_INCREMENT PRIMARY KEY,
author_last VARCHAR(50),
author_first VARCHAR(50),
country VARCHAR(50));")


# Add data into the tables
dbSendQuery(mydb, 
            "INSERT INTO authors (author_last, author_first, country)
             VALUES ('Kumar', 'Manoj', 'India');")


# Get the last inserted
last_id <- fetch(dbSendQuery(mydb, "SELECT LAST_INSERT_ID();"))

last_id

# Insert into books using the last_id
dbString <- sprintf("INSERT INTO books (title, author_id, isbn, genre, pub_year)
                    VALUES('R and MySQL', %i, '6900690075', 'tutorials', '2014');", last_id[1, 1])

# Create record in books
dbSendQuery(mydb, dbString)

# Take a look at the table
fetch(dbSendQuery(mydb, "SELECT * FROM books;"))

# Return what is inside db to a dataframe
df <- fetch(dbSendQuery(mydb, "SELECT * FROM authors;"))

# Shut down the connection
dbDisconnect(mydb)

# Print data frame
df