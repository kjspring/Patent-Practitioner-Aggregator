# Download the USPTO practitioner and save in mySQL database
library(RMySQL)



con <- dbConnect(MySQL(), user="root", password="Ab1t0715@!z",
                 dbname="practitioner", host="localhost")


dbListTables(con)

"CREATE TABLE USPTO(
id INT NOT NULL AUTO_INCREMENT, 
PRIMARY KEY(id),
last VARCHAR(255), 
first VARCHAR(255),
middle VARCHAR(255),
firm VARCHAR(255),
address VARCHAR(255),
address2 VARCHAR(255),
city VARCHAR(255),
state VARCHAR(255),
country VARCHAR(255),
zip VARCHAR(255),
telephone VARCHAR(255),
regNo VARCHAR(255)"
address
age INT)")
or die(mysql_error());  


filename <- "~/Dropbox/projects/patent_site/WebRoster.txt"
dat <- read.csv(filename, header=F, colClasses = "character")

colnames(dat) <- c("last", "first", "middle", "suffix", "firm", "address1", "address2", "address3", "city", "state", "country", "zip", "telephone", "regNo", "class")

# Remove last NA column
dat$ext <- ""
dat <- dat[,-16]
dat[dat == ""] <- NA
dat[dat == "--"] <- NA

# Clean up the telephone data

# Put the extensions into its own column
EXTs <- grep("EXT", dat$telephone)

for (i in 1:length(EXTs)) {
  sp <- strsplit(dat[EXTs[i],]$telephone, "EXT")
  dat[EXTs[i],]$telephone <- sp[[1]][1]
  dat[EXTs[i],]$ext <- sp[[1]][2]
  }

# Also have extensions listed as 'X'
Xs <- grep("X", dat$telephone)

for (i in 1:length(Xs)) {
  sp <- strsplit(dat[Xs[i],]$telephone, "X")
  dat[Xs[i],]$telephone <- sp[[1]][1]
  dat[Xs[i],]$ext <- sp[[1]][2]
  }

# Get rid of '.' and spaces in extension columns
bad_char <- grep(" ", dat$ext)
for (i in 1:length(bad_char)) {
  sp <- strsplit(dat[bad_char[i],]$ext, " ")
  dat[bad_char[i],]$ext <- sp[[1]][1]
}


dat$ext <- str_replace_all(dat$ext, "[[:punct:]]", "")
dat$ext <- str_replace_all(dat$ext, "[[:blank:]]", "")

dat$telephone <- str_replace_all(dat$telephone, "[[:alpha:]]", "")
dat$telephone <- str_replace_all(dat$telephone, "[[:space:]]", "")

# Clean up middle
dat$middle <- str_replace_all(dat$middle, "[[:punct:]]", "")

