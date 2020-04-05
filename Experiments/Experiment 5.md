# Experiment 5

### Aim:

Tables with labels in R - multiple response variables excel function translations

### Theory:

`expss` computes and displays tables with support for ‘SPSS’-style labels, multiple / nested banners, weights, multiple-response variables and significance testing. There are facilities for nice output of tables in ‘knitr’, R notebooks, ‘Shiny’ and ‘Jupyter’ notebooks. Proper methods for labelled variables add value labels support to base R functions and to some functions from other packages. Additionally, the package offers useful functions for data processing in marketing research / social surveys - popular data transformation functions from ‘SPSS’ Statistics (‘RECODE’, ‘COUNT’, ‘COMPUTE’, ‘DO IF’, etc.) and ‘Excel’ (‘COUNTIF’, ‘VLOOKUP’, etc.). Package is intended to help people to move data processing from ‘Excel’/‘SPSS’ to R. See examples below. You can get help about any function by typing `?function_name` in the R console.

## Installation

`expss` is on CRAN, so for installation you can print in the console `install.packages("expss")`.

```
library(expss)data(mtcars)mtcars = apply_labels(mtcars,                      mpg = "Miles/(US) gallon",                      cyl = "Number of cylinders",                      disp = "Displacement (cu.in.)",                      hp = "Gross horsepower",                      drat = "Rear axle ratio",                      wt = "Weight (1000 lbs)",                      qsec = "1/4 mile time",                      vs = "Engine",                      vs = c("V-engine" = 0,                             "Straight engine" = 1),                      am = "Transmission",                      am = c("Automatic" = 0,                             "Manual"=1),                      gear = "Number of forward gears",                      carb = "Number of carburetors"
)
```

For quick cross-tabulation there are `fre` and `cro` family of function. For simplicity we demonstrate here only `cro_cpct` which caluclates column percent. Documentation for other functions, such as `cro_cases` for counts, `cro_rpct` for row percent, `cro_tpct` for table percent and `cro_fun` for custom summary functions can be seen by typing `?cro` and `?cro_fun` in the console.

```
# 'cro' examples
# just simple crosstabulation, similar to base R 'table' function
cro(mtcars$am, mtcars$vs)
```

```
# Table column % with multiple banners
cro_cpct(mtcars$cyl, list(total(), mtcars$am, mtcars$vs))
```

|                     | #Total |     | Transmission |        | Engine |
| ------------------- | ------ | --- | ------------ | ------ | ------ |
|                     |        |     | Automatic    | Manual |        |
| ---                 | ---    | --- | ---          | ---    | ---    |
| Number of cylinders |        |     |              |        |        |
| 4                   | 34.4   |     | 15.8         | 61.5   |        |
| 6                   | 21.9   |     | 21.1         | 23.1   |        |
| 8                   | 43.8   |     | 63.2         | 15.4   |        |
| #Total cases        | 32     |     | 19           | 13     |        |

```
# or, the same result with another notation
mtcars %>% calc_cro_cpct(cyl, list(total(), am, vs))
```

|                     | #Total |     | Transmission |        | Engine |
| ------------------- | ------ | --- | ------------ | ------ | ------ |
|                     |        |     | Automatic    | Manual |        |
| ---                 | ---    | --- | ---          | ---    | ---    |
| Number of cylinders |        |     |              |        |        |
| 4                   | 34.4   |     | 15.8         | 61.5   |        |
| 6                   | 21.9   |     | 21.1         | 23.1   |        |
| 8                   | 43.8   |     | 63.2         | 15.4   |        |
| #Total cases        | 32     |     | 19           | 13     |        |

```
# Table with nested banners (column %).          
mtcars %>% calc_cro_cpct(cyl, list(total(), am %nest% vs))      
```

We have more sophisticated interface for table construction with `magrittr` piping. Table construction consists of at least of three functions chained with pipe operator: `%>%`. At first we need to specify variables for which statistics will be computed with `tab_cells`. Secondary, we calculate statistics with one of the `tab_stat_*` functions. And last, we finalize table creation with `tab_pivot`, e. g.: `dataset %>% tab_cells(variable) %>% tab_stat_cases() %>% tab_pivot()`. After that we can optionally sort table with `tab_sort_asc`, drop empty rows/columns with `drop_rc` and transpose with `tab_transpose`. Resulting table is just a `data.frame` so we can use usual R operations on it. Detailed documentation for table creation can be seen via `?tables`. For significance testing see `?significance`. Generally, tables automatically translated to HTML for output in knitr or Jupyter notebooks. However, if we want HTML output in the R notebooks or in the RStudio viewer we need to set options for that: `expss_output_rnotebook()` or `expss_output_viewer()`.

## Excel functions translation guide

Let us consider Excel toy table:

|     | A   | B   | C   |
| --- | --- | --- | --- |
| 1   | 2   | 15  | 50  |
| 2   | 1   | 70  | 80  |
| 3   | 3   | 30  | 40  |
| 4   | 2   | 30  | 40  |

Code for creating the same table in R:

```
library(expss)w = text_to_columns("        a  b  c        2 15 50        1 70 80        3 30 40        2 30 40")
```

`w` is the name of our table.

##### IF

**Excel: `IF(B1>60, 1, 0)`**

**R:** Here we create new column with name `d` with results. `ifelse` function is from base R not from ‘expss’ package but included here for completeness.

```
w$d = ifelse(w$b>60, 1, 0)
```

If we need to use multiple transformations it is often convenient to use `compute` function. Inside `compute` we can put arbitrary number of the statements:

```
w = compute(w, {    d = ifelse(b>60, 1, 0)    e = 42
    abc_sum = sum_row(a, b, c)    abc_mean = mean_row(a, b, c)})
```

##### COUNTIF

Count 1’s in the entire dataset.

**Excel: `COUNTIF(A1:C4, 1)`**

**R:**

```
count_if(1, w)
```

or

```
calculate(w, count_if(1, a, b, c))
```

Count values greater than 1 in each row of the dataset.

**Excel: `COUNTIF(A1:C1, ">1")`**

**R**:

```
w$d = count_row_if(gt(1), w)  
```

or

```
w = compute(w, {    d = count_row_if(gt(1), a, b, c) })
```

Count values less than or equal to 1 in column A of the dataset.

**Excel: `COUNTIF(A1:A4, "<=1")`**

**R**:

```
count_col_if(le(1), w$a)
```

Table of criteria:

| Excel | R     |
| ----- | ----- |
| <1    | lt(1) |
| <=1   | le(1) |
| <>1   | ne(1) |
| =1    | eq(1) |
| >=1   | ge(1) |
| >1    | gt(1) |

##### SUM/AVERAGE

Sum all values in the dataset.

**Excel: `SUM(A1:C4)`**

**R:**

```
sum(w, na.rm = TRUE)
```

Calculate average of each row of the dataset.

**Excel: `AVERAGE(A1:C1)`**

**R**:

```
w$d = mean_row(w)  
```

or

```
w = compute(w, {    d = mean_row(a, b, c) })
```

### Screenshots:

#### Installation of `expss`

![](/home/akuma/SoopaProject/R/Experiments/img/Cheese_Sun-05Apr20_08.40.png)

#### Cross-tabulation Example:

![](/home/akuma/SoopaProject/R/Experiments/img/Cheese_Sun-05Apr20_08.44.png)

### Excel functions Example:

![](/home/akuma/SoopaProject/R/Experiments/img/Cheese_Sun-05Apr20_08.50.png)

### Conclusion:

Henceforth, we have successfully seen cross-tabulation and excel functions. 
