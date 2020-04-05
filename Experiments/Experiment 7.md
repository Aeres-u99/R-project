# Experiment 7

### Aim:

EDA with R - Range, Summary, Mean, Variance, Median, Standard Deviation, Histogram, Boxplot, Scatter Graph

### Theory:

EDA is an iterative cycle. wherein One:

1. Generate questions about one's data.

2. Search for answers by visualising, transforming, and modelling one's data.

3. Use what one learn to refine oner questions and/or generate new questions.

EDA is not a formal process with a strict set of rules. More than anything, EDA is a state of mind. During the initial phases of EDA one should feel free to investigate every idea that occurs to one. Some of these ideas will pan out, and some will be dead ends. As one's exploration continues, one will home in on a few particularly productive areas that one’ll eventually write up and communicate to others.

EDA is an important part of any data analysis, even if the questions are handed to one on a platter, because one always need to investigate the quality of oner data. Data cleaning is just one application of EDA: one ask questions about whether oner data meets oner expectations or not. To do data cleaning, one’ll need to deploy all the tools of EDA: visualisation, transformation, and modelling.

#### Definitive Terms:

* A **variable** is a quantity, quality, or property that one can measure.

* A **value** is the state of a variable when one measure it. The value of a variable may change from measurement to measurement.

* An **observation** is a set of measurements made under similar conditions (one usually make all of the measurements in an observation at the same time and on the same object). An observation will contain several values, each associated with a different variable. I’ll sometimes refer to an observation as a data point.

* **Tabular data** is a set of values, each associated with a variable and an observation. Tabular data is *tidy* if each value is placed in its own “cell”, each variable in its own column, and each observation in its own row.

## Variation

**Variation** is the tendency of the values of a variable to change from measurement to measurement. one can see variation easily in real life; if one measure any continuous variable twice, one will get two different results. This is true even if one measure quantities that are constant, like the speed of light. Each of one's measurements will include a small amount of error that varies from measurement to measurement. Categorical variables can also vary if one measure across different subjects (e.g. the eye colors of different people), or different times (e.g. the energy levels of an electron at different moments). Every variable has its own pattern of variation, which can reveal interesting information. The best way to understand that pattern is to visualise the distribution of the variable’s values.

A variable is **categorical** if it can only take one of a small set of values. In R, categorical variables are usually saved as factors or character vectors. To examine the distribution of a categorical variable, use a bar chart:

```r
ggplot(data = diamonds) +
  geom_bar(mapping = aes(x = cut))
```

![](/home/akuma/SoopaProject/R/Experiments/img/Cheese_Sun-05Apr20_09.15.png)

A variable is **continuous** if it can take any of an infinite set of ordered values. Numbers and date-times are two examples of continuous variables. To examine the distribution of a continuous variable, use a histogram:

```r
ggplot(data = diamonds) +
  geom_histogram(mapping = aes(x = carat), binwidth = 0.5)
```

![](/home/akuma/Screenshots/Cheese_Sun-05Apr20_09.38.png)

### Unusual values

Outliers are observations that are unusual; data points that don’t seem to fit the pattern. Sometimes outliers are data entry errors; other times outliers suggest important new science. When one have a lot of data, outliers are sometimes difficult to see in a histogram. For example, take the distribution of the `y` variable from the diamonds dataset. The only evidence of outliers is the unusually wide limits on the x-axis.

```r
ggplot(diamonds) + 
  geom_histogram(mapping = aes(x = y), binwidth = 0.5)
```

## Missing values

If one has encountered unusual values in one's dataset, and simply want to move on to the rest of one's analysis, one have two options.

1. Drop the entire row with the strange values:
   
   ```r
   diamonds2 <- diamonds %>% 
     filter(between(y, 3, 20))
   ```
   
   I don’t recommend this option because just because one measurement is invalid, doesn’t mean all the measurements are. Additionally, if one have low quality data, by time that one’ve applied this approach to every variable one might find that one don’t have any data left!

2. Instead, I recommend replacing the unusual values with missing values. The easiest way to do this is to use `mutate()` to replace the variable with a modified copy. one can use the `ifelse()` function to replace unusual values with `NA`:
   
   ```r
   diamonds2 <- diamonds %>% 
     mutate(y = ifelse(y < 3 | y > 20, NA, y))
   ```

## Covariation

If variation describes the behavior *within* a variable, covariation describes the behavior *between* variables. **Covariation** is the tendency for the values of two or more variables to vary together in a related way. The best way to spot covariation is to visualise the relationship between two or more variables. How you do that should again depend on the type of variables involved.

A **boxplot** is a type of visual shorthand for a distribution of values that is popular among statisticians. Each boxplot consists of:

* A box that stretches from the 25th percentile of the distribution to the 75th percentile, a distance known as the interquartile range (IQR). In the middle of the box is a line that displays the median, i.e. 50th percentile, of the distribution. These three lines give you a sense of the spread of the distribution and whether or not the distribution is symmetric about the median or skewed to one side.

* Visual points that display observations that fall more than 1.5 times the IQR from either edge of the box. These outlying points are unusual so are plotted individually.

* A line (or whisker) that extends from each end of the box and goes to the  farthest non-outlier point in the distribution.

```r
ggplot(data = diamonds, mapping = aes(x = cut, y = price)) +
  geom_boxplot()
```

![](/home/akuma/SoopaProject/R/Experiments/img/Cheese_Sun-05Apr20_09.43.png)

```r
ggplot(data = mpg) +
  geom_boxplot(mapping = aes(x = reorder(class, hwy, FUN = median), y = hwy)) +
  coord_flip()
```

![](/home/akuma/SoopaProject/R/Experiments/img/Cheese_Sun-05Apr20_09.44.png)

### Central Tendency

**Mean:** Calculate sum of all the values and divide it with the total number of values in the data set.

```
x <- c(1,2,3,4,5,1,2,3,1,2,4,5,2,3,1,1,2,3,5,6) # our data set

mean.result = mean(x) # calculate mean

print (mean.result)
```

**Median:** The middle value of the data set.

```r
x <- c(1,2,3,4,5,1,2,3,1,2,4,5,2,3,1,1,2,3,5,6)
median.result <- median(x)
print(median.result)
```

**Mode:** The most occurring number in the data set. For calculating mode, there is no default function in R. So, we have to create our own custom function.

```r
mode <- function(x) {
+     ux <- unique(x)
+     ux[which.max(tabulate(match(x, ux)))]
+ }
 x <- c(1,2,3,4,5,1,2,3,1,2,4,5,2,3,1,1,2,3,5,6) 
 mode.result = mode(x) 
 print (mode.result)
```

**Variance:** How far a set of data values are spread out from their mean.

```r
variance.result = var(x) 
print (variance.result)
```

**Standard Deviation:** A measure that is used to quantify the amount of variation or dispersion of a set of data values.

```r
sd.result = sqrt(var(x))
print (sd.result)
```

![](/home/akuma/SoopaProject/R/Experiments/img/Cheese_Sun-05Apr20_10.03.png)

### Conclusion:

Henceforth, we have successfully performed EDA, and studied central tendencies. 
