# Test Solutions

## 1. Easy Test (Easy.R)
Explains two basic AWK commands used with `fread()`.

- **Command 1:**  
  `awk -F ',' '{print}' 'diamonds.csv'`  
  Reads the entire CSV file through AWK and passes it directly to `fread()` without any modification.

- **Command 2:**  
  `awk -F ',' '{if(NR > 1) print $1, $2, $7/$1}' 'diamonds.csv'`  
  Skips the header row using `NR > 1`, selects specific columns (carat and cut), and computes a new value (price per carat). Uses `fill = TRUE` in `fread()` to handle structure differences.

---

## 2. Medium Test (Medium.R)
Applies filtering and aggregation using AWK inside `fread()`.

- **Task 1:**  
  Filters rows where `color == 'E'` and `price > 1500`. Keeps the header (`NR==1`), prints the result, and counts rows using `nrow()`.

- **Task 2:**  
  Uses AWK’s internal counter (`count++`) and `END { print count }` to count matching rows directly, without loading the filtered dataset into R.

- **Task 3:**  
  Applies multiple conditions:  
  - carat ≥ 1  
  - cut is Ideal or Premium  
  - color is E or F  
  - price ≥ 1000  

  The file is passed three times to AWK. `NR==1` keeps only the first header, while later headers are ignored automatically due to numeric conditions.

---

## 3. Hard Test (Hard.R)
Implements an R → AWK translation function.

- **R_to_awk():**  
  Converts R-style conditions into valid AWK commands.

- **Key Features:**
  - Replaces `and` with `&&`
  - Converts single quotes to standard double quotes for AWK compatibility
  - Translates `%in% c(...)` into multiple `||` conditions
  - Maps column names to AWK field indices using a dictionary:
    - carat → `$1`
    - cut → `$2`
    - color → `$3`
    - price → `$7`

- **Execution:**  
  Tests the following conditions:
  - `price >= 1000`
  - `carat <= 1 and color == 'E'`
  - `cut %in% c('Premium', 'Ideal')`

  Each condition is translated into an AWK command and executed using `fread()` to return the filtered dataset.