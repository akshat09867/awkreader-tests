library(ggplot2)
library(data.table)
setwd("~/Downloads")
fwrite(x = diamonds, file = "diamonds.csv")

R_to_awk <- function(r_query){
   awk_query <- gsub("and", "&&", r_query, ignore.case=TRUE)
    awk_query <- gsub("'", "\"", awk_query)

    if (grepl("%in%", awk_query)) {
    col_name <- trimws(strsplit(awk_query, "%in%")[[1]][1])
    
    match <- regmatches(awk_query, regexpr("c\\((.*?)\\)", awk_query))
    values_string <- gsub("c\\(|\\)", "", match)
    values_list <- trimws(unlist(strsplit(values_string, ",")))
    
    or_conditions <- paste(col_name, "==", values_list, collapse = " || ")
    expanded_in <- paste0("(", or_conditions, ")")
    
    awk_query <- gsub(paste0(col_name, "\\s*%in%\\s*c\\(.*?\\)"), expanded_in, awk_query)
  }

    col_dict <- c("carat" = "$1", "cut" = "$2", "color" = "$3", "price" = "$7")
    for (col in names(col_dict)) {
    awk_query <- gsub(paste0("\\b", col, "\\b"), col_dict[[col]], awk_query)
  }
   final_awk_cmd <- sprintf("awk -F ',' 'NR == 1 || (%s)' diamonds.csv", awk_query)
  
  return(final_awk_cmd)
}

cmd1 <- R_to_awk("price >= 1000")
print(cmd1)


result1 <- fread(cmd = cmd1)
print(result1)

cmd2 <- R_to_awk("carat <= 1 and color == 'E'")
print(cmd2)

result2 <- fread(cmd = cmd2)
print(result2)

cmd3 <- R_to_awk("cut %in% c('Premium', 'Ideal')")
print(cmd3)

result3 <- fread(cmd = cmd3)
print(result3)