# Experiment 9

### Aim:

Basic of correlation, simple and multiple regression in R

### Theory:

Correlation and linear regression each explore the relationship between two quantitative variables.  Both are very common analyses.

Correlation determines if one variable varies systematically as another variable changes.  It does not specify that one variable is the dependent variable and the other is the independent variable.  Often, it is useful to look at which variables are correlated to others in a data set, and it is especially useful to see which variables correlate to a particular variable of interest.

For this experiment we will be using the custom data and performing the experiments.



```r
### --------------------------------------------------------------
### Correlation and linear regression, species diversity example
### pp. 207–208
### --------------------------------------------------------------

Input = ("
Town                  State  Latitude  Species
'Bombay Hook'          DE     39.217    128
'Cape Henlopen'        DE     38.800    137
'Middletown'           DE     39.467    108
'Milford'              DE     38.958    118
'Rehoboth'             DE     38.600    135
'Seaford-Nanticoke'    DE     38.583     94
'Wilmington'           DE     39.733    113
'Crisfield'            MD     38.033    118
'Denton'               MD     38.900     96
'Elkton'               MD     39.533     98
'Lower Kent County'    MD     39.133    121
'Ocean City'           MD     38.317    152
'Salisbury'            MD     38.333    108
'S Dorchester County'  MD     38.367    118
'Cape Charles'         VA     37.200    157
'Chincoteague'         VA     37.967    125
'Wachapreague'         VA     37.667    114
")

Data = read.table(textConnection(Input),header=TRUE)
```

So as to generate the simple plot for the data,

```r
plot(Species ~ Latitude,
     data=Data,
     pch=16,
     xlab = "Latitude",
     ylab = "Species")
```

![](/home/akuma/SoopaProject/R/Experiments/img/Cheese_Sun-05Apr20_11.05.png)

#### Correlation

Correlation can be performed with the *cor.test* function in the native *stats* package.  It can perform Pearson, Kendall, and Spearman correlation procedures.  Methods for multiple correlation of several variables simultaneously are discussed in the *Multiple regression* chapter.

#### Pearson correlation

Pearson correlation is the most common form of correlation.  It is a parametric test, and assumes that the data are linearly related and that the residuals are normally distributed.

```r
cor.test( ~ Species + Latitude,
         data=Data,
         method = "pearson",
         conf.level = 0.95)
#Pearson's product-moment correlation
t = -2.0225, df = 15, p-value = 0.06134
       cor
-0.4628844
```

![](/home/akuma/Screenshots/Cheese_Sun-05Apr20_11.05.png)

#### Kendall correlation

Kendall rank correlation is a non-parametric test that does not assume a distribution of the data or that the data are linearly related.  It ranks the data to determine the degree of correlation.

```r
cor.test( ~ Species + Latitude,
         data=Data,
         method = "kendall",
         continuity = FALSE,
         conf.level = 0.95)
Kendall's rank correlation tau
z = -1.3234, p-value = 0.1857
       tau
-0.2388326
```

#### Spearman correlation

Spearman rank correlation is a non-parametric test that does not assume a distribution of the data or that the data are linearly related.  It ranks the data to determine the degree of correlation, and is appropriate for ordinal measurements.

```r

cor.test( ~ Species + Latitude,
         data=Data,
         method = "spearman",
         continuity = FALSE,
         conf.level = 0.95)

 

Spearman's rank correlation rho
S = 1111.908, p-value = 0.1526
       rho
-0.3626323
```

#### Linear regression

Linear regression can be performed with the *lm* function in the native *stats* package.  A robust regression can be performed with the *lmrob* function in the *robustbase* package.

```r
model = lm(Species ~ Latitude,
           data = Data)

summary(model)                    # shows parameter estimates,
                                  # p-value for model, r-square
            Estimate Std. Error t value Pr(>|t|) 
(Intercept)  585.145    230.024   2.544   0.0225 *

Latitude     -12.039      5.953  -2.022   0.0613 .
Multiple R-squared:  0.2143,  Adjusted R-squared:  0.1619
F-statistic:  4.09 on 1 and 15 DF,  p-value: 0.06134
library(car)
Anova(model, type="II")              # shows p-value for effects in model
Response: Species
          Sum Sq Df F value  Pr(>F) 
Latitude  1096.6  1  4.0903 0.06134 .
Residuals 4021.4 15
```

```r

int =  model$coefficient["(Intercept)"]
slope =model$coefficient["Latitude"]

plot(Species ~ Latitude,
     data = Data,
     pch=16,
     xlab = "Latitude",
     ylab = "Species")

abline(int, slope,
       lty=1, lwd=2, col="blue")
```

![](/home/akuma/.config/marktext/images/2020-04-05-11-13-00-image.png)

```r
hist(residuals(model),
     col="darkgray")
```

![](/home/akuma/.config/marktext/images/2020-04-05-11-13-27-image.png)

![](/home/akuma/Screenshots/Cheese_Sun-05Apr20_11.14.png)

### Conclusion:

Henceforth, we have successfully studied Basics of correlation and regression in R.


