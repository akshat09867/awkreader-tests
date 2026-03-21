library(ggplot2)
library(data.table)
setwd("~/Downloads")
fwrite(x = diamonds[1:5,], file = "diamonds.csv")


#Command 1
fread(cmd = "awk -F ',' '{print}' 'diamonds.csv'")

# awk: Invokes the AWK utility.
# -F ',': This sets the Field Separator. Since this file is a CSV (Comma Separated Values), this tells AWK to treat every comma as a boundary between columns.
# '{print}': This is the action block. In AWK, if print is called without any specific arguments, it defaults to printing the entire line.
# 'diamonds.csv': The target file AWK is reading.
# The Result: This command simply reads the file and passes every line and every column directly to fread. It functions exactly like a standard fread("diamonds.csv"), but uses AWK as a middleman.

#Command 2
fread(cmd = "awk -F ',' '{if(NR > 1) print $1, $2, $7/$1}' 'diamonds.csv'", fill = T)

# NR > 1: NR stands for Number of Records (the current line number). By checking if NR > 1, AWK skips the first line. In a CSV, the first line is usually the header.
# $1, $2: This tells AWK to only print the 1st column (carat) and the 2nd column (cut).
# $7/$1: This is a dynamic calculation. It takes the value in the 7th column (price) and divides it by the 1st column (carat).
#fill = T: This is an R-specific argument for fread. Since the AWK command skipped the header line (NR > 1), the resulting data stream doesn't have column names. fill = T helps fread handle the structure of the incoming data gracefully.
#The Result: We get a data table with three columns (carat, cut, and price-per-carat) for the first five diamonds, excluding the original header.