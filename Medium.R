library(ggplot2)
library(data.table)
setwd("~/Downloads")
fwrite(x = diamonds, file = "diamonds.csv")

# 1.
task1 <- fread(cmd="awk -F ',' 'NR==1 || ($3==\"E\"&& $7>1500)' diamonds.csv")
print(task1)
nrow(task1)

# 2.
task2 <- fread(cmd="awk -F ',' '$3==\"E\"&& $7>1500{count++} END {print count}' diamonds.csv")
print(task2)

# 3.
task3 <- fread(cmd="awk -F ',' '(NR==1) ||($1>=1 && ($2==\"Ideal\"||$2==\"Premium\") && ($3==\"E\"|| $3==\"F\") && $7>=1000)' diamonds.csv diamonds.csv diamonds.csv")
print(task3)
nrow(task3)
