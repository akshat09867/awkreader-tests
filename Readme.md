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
* **Shallow Header Read:** The engine uses `readLines(path, n = 1)` to perform a high-speed "peek" at the file's first row. This allows it to map human-readable column names to AWK field indices ($1, $2, etc.) on the fly without loading the dataset into memory.
* **Dataset-Agnostic Design:** By passing the `path` variable to the translator, the function can now process any CSV regardless of its schema or column count.
* **Operator Normalization:** Automatically converts R-style logical operators (`and`/`or`) and quotes into AWK-compliant syntax (`&&`/`||` and `"`).
* **Vector Expansion:** Translates R's `%in% c(...)` syntax into a series of logical `||` (OR) statements, enabling complex set-membership filtering directly in the shell.
* **Regex Word Boundaries:** Uses `\\b` regex markers during substitution to ensure column names are matched exactly (e.g., preventing a column named `carat` from accidentally matching `carat_weight`).

### Execution & Validation

The function `R_to_awk(path, r_query)` was validated using the following test cases on the `diamonds` dataset:

| R Query | Translated AWK Logic |
| :--- | :--- |
| `price >= 1000` | `$7 >= 1000` |
| `carat <= 1 and color == 'E'` | `$1 <= 1 && $3 == "E"` |
| `cut %in% c('Premium', 'Ideal')` | `($2 == "Premium" \|\| $2 == "Ideal")` |

Each translated command is executed via `data.table::fread(cmd = ...)` to confirm that the AWK-filtered results match the expected R-subsetted output.