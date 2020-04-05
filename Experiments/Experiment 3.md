# Experiment 3

### Aim:

Basic datatypes and data structures in R - vectors, metrics, list and dataframes.

### Theory:

Variables can contain values of specific types within R. The six **data types** that R uses include:

* `"numeric"` for any numerical value
* `"character"` for text values, denoted by using quotes (“”) around value
* `"integer"` for integer numbers (e.g., `2L`, the `L` indicates to R that it’s an integer)
* `"logical"` for `TRUE` and `FALSE` (the Boolean data type)
* `"complex"` to represent complex numbers with real and imaginary parts (e.g., `1+4i`) and that’s all we’re going to say about them
* `"raw"` that we won’t discuss further

The table below provides examples of each of the commonly used data types:

| Data Type  | Examples               |
| ---------- |:----------------------:|
| Numeric:   | 1, 1.5, 20, pi         |
| Character: | “anytext”, “5”, “TRUE” |
| Integer:   | 2L, 500L, -17L         |
| Logical:   | TRUE, FALSE, T, F      |

#### Data Structures

We know that variables are like buckets, and so far we have seen that bucket filled with a single value. Even when `number` was created, the result of the mathematical operation was a single value. **Variables can store more than just a single value, they can store a multitude of different data structures.** These include, but are not limited to, vectors (`c`), factors (`factor`), matrices (`matrix`), data frames (`data.frame`) and lists (`list`).

##### Vectors

A vector is the most common and basic data structure in R, and is pretty much the workhorse of R. It’s basically just a collection of values, mainly either numbers, characters or logical values. 

**Note: All values in a vector must be of the same data type.** If you try to create a vector with more than a single data type, R will try to coerce it into a single data type.

Each element of this vector contains a single numeric value, and three values will be combined together into a vector using `c()` (the combine function). All of the values are put within the parentheses and separated with a comma.

```r
glengths <- c(4.6, 3000, 50000)
glengths
```

Similarly, 

```r
species <- c("ecoli","human","corn")
```

### Matrix

A `matrix` in R is a collection of vectors of **same length and identical datatype**. Vectors can be combined as columns in the matrix or by row, to create a 2-dimensional structure.

Matrices are used commonly as part of the mathematical machinery of statistics. They are usually of numeric datatype and used in computational algorithms to serve as a checkpoint. For example, if input data is not of identical data type (numeric, character, etc.), the `matrix()` function will throw an error and stop any downstream code execution.

### Data Frame

A `data.frame` is the *de facto* data structure for most tabular data and what we use for statistics and plotting. A `data.frame` is similar to a matrix in that it’s a collection of vectors of the **same length** and each vector represents a column. However, in a dataframe **each vector can be of a different data type** (e.g., characters, integers, factors).

We can create a dataframe by bringing **vectors** together to **form the columns**. We do this using the `data.frame()` function, and giving the function the different vectors we would like to bind together. *This function will only work for vectors of the same length.*

```r
df <- data.frame(species, glengths)
```

Beware of `data.frame()`’s default behaviour which turns **character vectors into factors**. Print your data frame to the console:

```
df
```

### Lists

Lists are a data structure in R that can be perhaps a bit daunting at first, but soon become amazingly useful. A list is a data structure that can hold any number of any types of other data structures.

```
list1 <- list(species, df, number)
```

Print out the list to screen to take a look at the components:

```
list1

[[1]]
[1] "ecoli" "human" "corn" 

[[2]]
  species glengths
1   ecoli      4.6
2   human   3000.0
3    corn  50000.0

[[3]]
[1] 5
```

#### Screenshot:

![](/home/akuma/SoopaProject/R/Experiments/img/Cheese_Sat-04Apr20_18.40.png)

#### Conclusion:

Henceforth, we have successfully understood R datatypes and datastructures.
