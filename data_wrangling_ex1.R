# Libraries to use - recent warning errors on version 3.3.3 for lower level libraries so including it
#twice
library(tidyverse)
library(dplyr)

# Read the CSV file for use - Header = True and sep = "," as it's a excel file
refined <- read.csv("refine_original.csv")

# Make company names lower case first with one command : assign to refined company column
refined$company <- tolower(refined$company)

# Using a sub function to correct company names this is easier then an easy assignment for each name
# replaces the first match of a string, if the parameter is a string vector, replaces the first match of all elements.
# Can also use Gsub function
refined$company <- sub(pattern = ".*\\ps$", replacement = "philips", x = refined$company) # end of word philips or phillips
refined$company <- sub(pattern = "^ak.*", replacement = "akzo", x = refined$company) # beginning of word akzo or akz0
refined$company <- sub(pattern = "^u.*", replacement = "unilever", x = refined$company)
refined$company <- sub(pattern = "^v.*", replacement = "van houten", x = refined$company)

# Use separate on the "Product.code...number" column that has used a "-" between product code and the number
refined <- separate(refined, "Product.code...number", c("product_code", "product_number"), sep = "-")

# Create a new column with a correct version of product category while changing the product names
refined$product_category <- sub(pattern = "^p$", replacement = "Smartphone", x = sub("^x$", "Laptop",
sub("^v$", "TV", sub("^q$", "Tablet", refined$product_code))))

# Create a column with the full address separated by commas using unite function
refined <- unite(refined, full_address, address:country, sep = ",")

# Create dummy variables for company and product category
refined <- mutate(refined, company_philips = ifelse(company == "philips", 1, 0))
refined <- mutate(refined, company_akzo = ifelse(company == "akzo", 1, 0))
refined <- mutate(refined, company_van_houten = ifelse(company == "van houten", 1, 0))
refined <- mutate(refined, company_unilever = ifelse(company == "unilever", 1, 0))
refined <- mutate(refined, product_smartphone = ifelse(product_category == "smartphone", 1, 0))
refined <- mutate(refined, product_tv = ifelse(product_category == "TV", 1, 0))
refined <- mutate(refined, product_laptop = ifelse(product_category == "Laptop", 1, 0))
refined <- mutate(refined, product_tablet = ifelse(product_category == "Tablet", 1, 0))

# Write out new CSV file with cleaned up changes documented above
write.csv(refined,"refine_clean.csv")
