# R-project

## Predict Income Level from Census Data
*-
The data was extracted from 1994 Census bureau database. Please view the adult.csv file for the dataset, this dataset is what is being used in the entire study of ours.

`income <- read.csv('adult.csv', na.strings = c('','?'))`
To assign the csv data into variable income, the na.strings is basically used to specify the content that is unknown in the dataset or left blank. 

`sapply(income,function(x) sum(is.na(x)))` basically counts the data that is unavailable. 

After finding it out, I realized that numbers are a bit annoying to comprehend and select the reliable points, henceforth we went ahead and plotted the graphs of it to see how they are.

```
library(Amelia)
missmap(income, main = "Missing values vs observed")
table (complete.cases (income))`
```

This basically allows us to see the plot of missing and observed data.

`Check Rplots.pdf for the plot`

Since the dataset has already been cleaned running it up again, will not show any false values. 

```R>
library(Amelia)
Loading required package: foreign
## 
## Amelia II: Multiple Imputation
## (Version 1.6.4, built: 2012-12-17)
## Copyright (C) 2005-2020 James Honaker, Gary King and Matthew Blackwell
## Refer to http://gking.harvard.edu/amelia/ for more information
## 
> missmap(income, main = "Missing values vs observed")
> table (complete.cases (income))

 TRUE 
32561 

```
So we go ahead and make a boxplot of everything with respect to income level. 
```R
library(gridExtra)
p1 <- ggplot(aes(x=income, y=age), data = income) + geom_boxplot() + 
  ggtitle('Age vs. Income Level')
p2 <- ggplot(aes(x=income, y=education.num), data = income) + geom_boxplot() +
  ggtitle('Years of Education vs. Income Level')
str(income) 
p3 <- ggplot(aes(x=income, y=house.per.week), data = income) + geom_boxplot() + ggtitle('Hours Per week vs. Income Level')
p4 <- ggplot(aes(x=income, y=capital.gain), data=income) + geom_boxplot() + 
  ggtitle('Capital Gain vs. Income Level')
p5 <- ggplot(aes(x=income, y=capital.loss), data=income) + geom_boxplot() +
  ggtitle('Capital Loss vs. Income Level')
p6 <- ggplot(aes(x=income, y=fnlwgt), data=income) + geom_boxplot() +
  ggtitle('Final Weight vs. Income Level')
grid.arrange(p1, p2, p3, p4, p5, p6, ncol=3)
income$fnlwgt <- NULL 
```

“Age”, “Years of education” and “hours per week” all show significant variations with income level. Therefore, they are kept for the regression analysis. “Final Weight” does not show any variation with income level, therefore, it has been excluded from the analysis. Its hard to see whether “Capital gain” and “Capital loss” have variation with Income level from the above plot, so we shall keep them for now.

```R
library(dplyr)
by_workclass <- income %>% group_by(workclass, income) %>% summarise(n=n())
by_education <- income %>% group_by(education, income) %>% summarise(n=n())
by_education$education <- ordered(by_education$education, 
                                   levels = c('Preschool', '1st-4th', '5th-6th', '7th-8th', '9th', '10th', '11th', '12th', 'HS-grad', 'Prof-school', 'Assoc-acdm', 'Assoc-voc', 'Some-college', 'Bachelors', 'Masters', 'Doctorate'))
by_marital <- income %>% group_by(marital.status, income) %>% summarise(n=n())
by_occupation <- income %>% group_by(occupation, income) %>% summarise(n=n())
by_relationship <- income %>% group_by(relationship, income) %>% summarise(n=n())
by_race <- income %>% group_by(race, income) %>% summarise(n=n())
by_sex <- income %>% group_by(sex, income) %>% summarise(n=n())
by_country <- income %>% group_by(native.country, income) %>% summarise(n=n())
p7 <- ggplot(aes(x=workclass, y=n, fill=income), data=by_workclass) + geom_bar(stat = 'identity', position = position_dodge()) + ggtitle('Workclass with Income Level') + theme(axis.text.x = element_text(angle = 45, hjust = 1))
p8 <- ggplot(aes(x=education, y=n, fill=income), data=by_education) + geom_bar(stat = 'identity', position = position_dodge()) + ggtitle('Education vs. Income Level') + coord_flip()
p9 <- ggplot(aes(x=marital.status, y=n, fill=income), data=by_marital) + geom_bar(stat = 'identity', position=position_dodge()) + ggtitle('Marital Status vs. Income Level') + theme(axis.text.x = element_text(angle = 45, hjust = 1))
p10 <- ggplot(aes(x=occupation, y=n, fill=income), data=by_occupation) + geom_bar(stat = 'identity', position=position_dodge()) + ggtitle('Occupation vs. Income Level') + coord_flip()
p11 <- ggplot(aes(x=relationship, y=n, fill=income), data=by_relationship) + geom_bar(stat = 'identity', position=position_dodge()) + ggtitle('Relationship vs. Income Level') + coord_flip()
p12 <- ggplot(aes(x=race, y=n, fill=income), data=by_race) + geom_bar(stat = 'identity', position = position_dodge()) + ggtitle('Race vs. Income Level') + coord_flip()
p13 <- ggplot(aes(x=sex, y=n, fill=income), data=by_sex) + geom_bar(stat = 'identity', position = position_dodge()) + ggtitle('Sex vs. Income Level')
p14 <- ggplot(aes(x=native.country, y=n, fill=income), data=by_country) + geom_bar(stat = 'identity', position = position_dodge()) + ggtitle('Native Country vs. Income Level') + coord_flip()
grid.arrange(p7, p8, p9, p10, ncol=2)
grid.arrange(p11,p12,p13, ncol=2)
```
Most of the data is collected from the United States, so variable “native country” does not have effect on our analysis, We shall exclude it from regression model. And all the other categorial variables seem to have reasonable variation, so they will be kept.

`income$income = as.factor(ifelse(income$income==income$income[1],0,1))`
basically if >50k it will be set to 1 else to 0

```R
train <- income[1:22793,]
test <- income[22793:32561,]
model <-glm(income ~.,family=binomial(link='logit'),data=train)
summary(model)
```

So as to fit the model and view the details.

```R
Deviance Residuals: 
    Min       1Q   Median       3Q      Max  
-4.9275  -0.5171  -0.1885  -0.0327   3.2694  

Coefficients: (2 not defined because of singularities)
                                       Estimate Std. Error z value Pr(>|z|)    
(Intercept)                          -8.325e+00  4.908e-01 -16.963  < 2e-16 ***
age                                   2.505e-02  1.932e-03  12.961  < 2e-16 ***
workclass Federal-gov                 1.100e+00  1.818e-01   6.055 1.41e-09 ***
workclass Local-gov                   4.509e-01  1.660e-01   2.716 0.006599 ** 
workclass Never-worked               -9.225e+00  6.808e+02  -0.014 0.989189    
workclass Private                     6.245e-01  1.481e-01   4.216 2.49e-05 ***
workclass Self-emp-inc                8.046e-01  1.766e-01   4.557 5.20e-06 ***
workclass Self-emp-not-inc            1.674e-01  1.623e-01   1.031 0.302392    
workclass State-gov                   2.851e-01  1.804e-01   1.580 0.114139    
workclass Without-pay                -1.279e+01  4.165e+02  -0.031 0.975497    
education 11th                        3.831e-02  2.421e-01   0.158 0.874287    
education 12th                        3.946e-01  3.182e-01   1.240 0.214856    
education 1st-4th                    -5.194e-01  5.324e-01  -0.976 0.329244    
education 5th-6th                    -4.645e-01  3.784e-01  -1.228 0.219579    
education 7th-8th                    -4.160e-01  2.683e-01  -1.550 0.121113    
education 9th                        -4.346e-01  3.154e-01  -1.378 0.168233    
education Assoc-acdm                  1.312e+00  2.054e-01   6.388 1.68e-10 ***
education Assoc-voc                   1.307e+00  1.972e-01   6.627 3.43e-11 ***
education Bachelors                   1.885e+00  1.821e-01  10.351  < 2e-16 ***
education Doctorate                   2.840e+00  2.522e-01  11.261  < 2e-16 ***
education HS-grad                     7.689e-01  1.773e-01   4.336 1.45e-05 ***
education Masters                     2.181e+00  1.947e-01  11.204  < 2e-16 ***
education Preschool                  -1.996e+01  2.167e+02  -0.092 0.926598    
education Prof-school                 2.614e+00  2.353e-01  11.109  < 2e-16 ***
education Some-college                1.062e+00  1.802e-01   5.897 3.71e-09 ***
education.num                                NA         NA      NA       NA    
marital.status Married-AF-spouse      2.687e+00  6.768e-01   3.970 7.19e-05 ***
marital.status Married-civ-spouse     2.246e+00  3.188e-01   7.043 1.88e-12 ***
marital.status Married-spouse-absent -2.308e-02  2.629e-01  -0.088 0.930043    
marital.status Never-married         -3.864e-01  1.039e-01  -3.718 0.000201 ***
marital.status Separated              5.553e-02  1.931e-01   0.288 0.773704    
marital.status Widowed                1.271e-01  1.917e-01   0.663 0.507395    
occupation Adm-clerical               1.184e-02  1.163e-01   0.102 0.918946    
occupation Armed-Forces              -1.325e+01  5.210e+02  -0.025 0.979717    
occupation Craft-repair               1.318e-01  9.983e-02   1.320 0.186672    
occupation Exec-managerial            8.385e-01  1.027e-01   8.166 3.19e-16 ***
occupation Farming-fishing           -9.949e-01  1.696e-01  -5.867 4.45e-09 ***
occupation Handlers-cleaners         -6.268e-01  1.732e-01  -3.620 0.000295 ***
occupation Machine-op-inspct         -3.041e-01  1.256e-01  -2.420 0.015510 *  
occupation Other-service             -7.233e-01  1.435e-01  -5.041 4.63e-07 ***
occupation Priv-house-serv           -1.205e+01  1.174e+02  -0.103 0.918289    
occupation Prof-specialty             6.148e-01  1.103e-01   5.573 2.50e-08 ***
occupation Protective-serv            5.988e-01  1.526e-01   3.924 8.70e-05 ***
occupation Sales                      2.675e-01  1.058e-01   2.527 0.011507 *  
occupation Tech-support               7.188e-01  1.403e-01   5.125 2.98e-07 ***
occupation Transport-moving                  NA         NA      NA       NA    
relationship Not-in-family            5.715e-01  3.148e-01   1.815 0.069470 .  
relationship Other-relative          -5.502e-01  2.934e-01  -1.876 0.060718 .  
relationship Own-child               -6.178e-01  3.113e-01  -1.984 0.047209 *  
relationship Unmarried                3.774e-01  3.342e-01   1.129 0.258751    
relationship Wife                     1.357e+00  1.213e-01  11.193  < 2e-16 ***
race Asian-Pac-Islander               2.078e-01  2.824e-01   0.736 0.461944    
race Black                            3.286e-01  2.690e-01   1.222 0.221864    
race Other                           -5.340e-01  4.306e-01  -1.240 0.214975    
race White                            4.402e-01  2.565e-01   1.716 0.086104 .  
sex Male                              8.320e-01  9.420e-02   8.832  < 2e-16 ***
capital.gain                          3.039e-04  1.187e-05  25.598  < 2e-16 ***
capital.loss                          6.484e-04  4.445e-05  14.587  < 2e-16 ***
house.per.week                        2.919e-02  1.934e-03  15.094  < 2e-16 ***
---
Signif. codes:  0 ‘***’ 0.001 ‘**’ 0.01 ‘*’ 0.05 ‘.’ 0.1 ‘ ’ 1

(Dispersion parameter for binomial family taken to be 1)

    Null deviance: 25044  on 22792  degrees of freedom
Residual deviance: 14581  on 22736  degrees of freedom
AIC: 14695

Number of Fisher Scoring iterations: 14

Analysis of Deviance Table

Model: binomial, link: logit

Response: income

Terms added sequentially (first to last)


               Df Deviance Resid. Df Resid. Dev  Pr(>Chi)    
NULL                           22792      25044              
age             1   1152.1     22791      23892 < 2.2e-16 ***
workclass       8    558.3     22783      23334 < 2.2e-16 ***
education      15   2551.2     22768      20783 < 2.2e-16 ***
education.num   0      0.0     22768      20783              
marital.status  6   3687.4     22762      17096 < 2.2e-16 ***
occupation     13    552.5     22749      16543 < 2.2e-16 ***
relationship    5    165.6     22744      16377 < 2.2e-16 ***
race            4     19.9     22740      16358 0.0005324 ***
sex             1    105.8     22739      16252 < 2.2e-16 ***
capital.gain    1   1210.5     22738      15041 < 2.2e-16 ***
capital.loss    1    227.1     22737      14814 < 2.2e-16 ***
house.per.week  1    233.4     22736      14581 < 2.2e-16 ***
---
Signif. codes:  0 ‘***’ 0.001 ‘**’ 0.01 ‘*’ 0.05 ‘.’ 0.1 ‘ ’ 1
[1] "Accuracy : 0.851776026205343"
```

Which gives an accuracy of upto 85%.

# Conclusions
Interpreting the results of the logistic regression model:

* “Age”, “Hours per week”, “sex”, “capital gain” and “capital loss” are the most statistically significant variables. Their lowest p-values suggesting a strong association with the probability of wage>50K from the data.
* “Workclass”, “education”, “marital status”, “occupation” and “relationship” are all across the table. so cannot be eliminated from the model.
* Which basically implies the role of each in earning and salary.
* “Race” category is not statistically significant and can be eliminated from the model.


*This project is mainly a subset from susanli2016 's Census income*

It has been adapted for simplification and understanding at begginer level and for our need of mini project
