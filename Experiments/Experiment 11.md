# Experiment 11

### Aim:

Classification on large and noisy dataset with R - logistic regression and naive bayes.

### Theory:

Logistic regression is yet another technique borrowed by machine learning from the field of statistics. It's a powerful statistical way of modeling a binomial outcome with one or more explanatory variables. It measures the relationship between the categorical dependent variable and one or more independent variables by estimating probabilities using a logistic function, which is the cumulative logistic distribution.

Logistic regression is an instance of classification technique that you can use to predict a qualitative response. More specifically, logistic regression models the probability that belongs to a particular category.

That means that, if you are trying to do gender classification, where the response falls into one of the two categories, `male` or `female`, you'll use logistic regression models to estimate the probability that belongs to a particular category.

## Who survived the Titanic disaster?

For illustration, we'll be working on one of the most popular data sets in machine learning: **Titanic**. It's fairly small in size and a variety of variables will give us enough space for creative feature engineering and model building. This data set has been taken from Kaggle. I hope you know that model building is the last stage in machine learning. Therefore, we'll be doing quick data exploration, pre-processing, and feature engineering before implementing Logistic Regression. 

```r
#set working directory
 path <- "~/SoopaProject/R/"
 setwd(path)

#load libraries and data
 library (data.table)
 library (plyr)
 library (stringr)
 train <- fread("train.csv",na.strings = c(""," ",NA,"NA"))
 test <- fread("test.csv",na.strings = c(""," ",NA,"NA"))
```

![](/home/akuma/Screenshots/Cheese_Sun-05Apr20_11.55.png)

```r
#check missing values
> colSums(is.na(train))
 colSums(is.na(test))
```

We see that variable `Age` and `Cabin` have missing values. Interestingly, the variable `Fare` has one missing value only in the test set. Let's start exploring each variable individually. For numeric variables, we'll use the`summary` function. For character / factor variables, we'll use table for exploration:

```r
#Quick Data Exploration
 summary(train$Age)
 summary(test$Age)

 train[,.N/nrow(train),Pclass]
 test[,.N/nrow(test),Pclass]

 train [,.N/nrow(train),Sex]
 test [,.N/nrow(test),Sex]

 train [,.N/nrow(train),SibSp]
 test [,.N/nrow(test),SibSp]

 train [,.N/nrow(train),Parch]
 test [,.N/nrow(test),Parch] #extra 9

 summary(train$Fare)
 summary(test$Fare)

 train [,.N/nrow(train),Cabin]
 test [,.N/nrow(test),Cabin]

 train [,.N/nrow(train),Embarked] 
 test [,.N/nrow(test),Embarked]
```

Following are the insights we can derive from the data exploration above:

1. The variable `Fare` is skewed (right) in nature. We'll have to log transform it such that it resembles a normal distribution.
2. The variable `Parch` has one extra level (9) in the test set as compared to the train set. We'll have to combine it with its mode value.

A smart way to make modifications in train and test data is by combining them. This way, you'll save yourself from writing some extra lines of code. I suggest you follow every line of code carefully and simultaneously check how every line affects the data.

```r
#combine data
> alldata <- rbind(train,test,fill=TRUE)
```

I suspect that `Ticket` notation could give us some information. For example, some ticket notation starts with alpha numeric, while others only have numbers. We'll capture this trend using a binary coded variable.

```r
#New Variables
#Extract passengers title
> alldata [,title := strsplit(Name,split = "[,.]")]
> alldata [,title := ldply(.data = title,.fun = function(x) x[2])]
> alldata [,title := str_trim(title,side = "left")]

#combine titles
> alldata [,title := replace(title, which(title %in% c("Capt","Col","Don","Jonkheer","Major","Rev","Sir")), "Mr"),by=title]
> alldata [,title := replace(title, which(title %in% c("Lady","Mlle","Mme","Ms","the Countess","Dr","Dona")),"Mrs"),by=title]

#ticket binary coding
> alldata [,abs_col := strsplit(x = Ticket,split = " ")]
> alldata [,abs_col := ldply(.data = abs_col,.fun = function(x)length(x))]
> alldata [,abs_col := ifelse(abs_col > 1,1,0)]
```

Next, we'll impute missing values, transform `Fare` variable and remove an extra level from `Parch` variable. This will make our data ready for machine learning.

```r
#Impute Age with Median
> for(i in "Age")
        set(alldata,i = which(is.na(alldata[[i]])),j=i,value = median(alldata$Age,na.rm = T))

#Remove rows containing NA from Embarked
> alldata <- alldata[!is.na(Embarked)]

#Impute Fare with Median
> for(i in "Fare")
      set(alldata,i = which(is.na(alldata[[i]])),j=i,value = median(alldata$Fare,na.rm = T))

#Replace missing values in Cabin with "Miss"
> alldata [is.na(Cabin),Cabin := "Miss"]

#Log Transform Fare
> alldata$Fare <- log(alldata$Fare + 1)

#Impute Parch 9 to 0
> alldata [Parch == 9L, Parch := 0]
```

The method of using for - set loop for imputing missing values works blazing fast on large data sets. In our case, the data set is small, hence it's difficult to note the difference. Now, our data set is ready. Let's implement Logistic Regression and check our model's accuracy.

```r
#Collect train and test
> train <- alldata[!(is.na(Survived))]
> train [,Survived := as.factor(Survived)]

> test <- alldata[is.na(Survived)]
> test [,Survived := NULL]

#Logistic Regression
> model <- glm(Survived ~ ., family = binomial(link = 'logit'), data = train[,-c("PassengerId","Name","Ticket")])
> summary(model)
```

In R, you can implement Logistic Regression using the `glm` function. Now, let's understand and interpret the crucial aspects of summary:

1. The glm function internally encodes categorical variables into n - 1 distinct levels.
2. Estimate represents the regression coefficients value. Here, the regression coefficients explain the change in log(odds) of the response variable for one unit change in the predictor variable.
3. Std. Error represents the standard error associated with the regression coefficients.
4. z value is analogous to t-statistics in multiple regression output. z value > 2 implies the corresponding variable is significant.
5. p value determines the probability of significance of predictor variables. With 95% confidence level, a variable having p < 0.05 is considered an important predictor. The same can be inferred by observing stars against p value.

In addition, we can also perform an ANOVA Chi-square test to check the overall effect of variables on the dependent variable.

```r
#run anova
> anova(model, test = 'Chisq')

```

![](/home/akuma/Screenshots/Cheese_Sun-05Apr20_11.58.png)

![](/home/akuma/Screenshots/Cheese_Sun-05Apr20_12.04.png)

we can also perform an ANOVA Chi-square test to check the overall effect of variables on the dependent variable.

```r
#run anova
> anova(model, test = 'Chisq')
```

![](/home/akuma/Screenshots/Cheese_Sun-05Apr20_12.07.png)

(**TOP LEFT**)

Following are the insights we can collect for the output above:

1. In the presence of other variables, variables such as Parch, Cabin, Embarked, and abs_col are not significant. We'll try building another model without including them.
2. The AIC value of this model is 883.79.

Let's create another model and try to achieve a lower AIC value.

```r
> model2 <- glm(Survived ~ Pclass + Sex + Age + SibSp + Fare + title, data = train,family = binomial(link="logit"))
> summary(model2)
```

As you can see, we've achieved a lower AIC value and a better model. Also, we can compare both the models using the ANOVA test. Let's say our null hypothesis is that second model is better than the first model. p < 0.05 would reject our hypothesis and in case p > 0.05, we'll fail to reject the null hypothesis.

```r
#compare two models
> anova(model,model2,test = "Chisq")
```

![anova output](http://blog.hackerearth.com/wp-content/uploads/2017/04/Selection_023.png)

With p > 0.05, this ANOVA test also corroborates the fact that the second model is better than first model. Let's predict on unseen data now. Since, we can't evaluate a model's performance on test data locally, we'll divide the train set and use model 2 for prediction.

```r
#partition and create training, testing data
> library(caret)
> split <- createDataPartition(y = train$Survived,p = 0.6,list = FALSE)

> new_train <- train[split] 
> new_test <- train[-split]

#model training and prediction
> log_model <- glm(Survived ~ Pclass + Sex + Age + SibSp + Fare + title, data = new_train[,-c("PassengerId","Name","Ticket")],family = binomial(link="logit"))
> log_predict <- predict(log_model,newdata = new_test,type = "response")
> log_predict <- ifelse(log_predict > 0.5,1,0)
```

For now, I've set the probability threshold value as 0.5. Let's get the flavor of our model's accuracy. We'll use AUC-ROC score to determine model fit. Higher the score, better the model. You can also use confusion matrix to determine accuracy using `confusionMatrix` function from caret package.

```r
#plot ROC 
> library(ROCR) 
> library(Metrics)
> pr <- prediction(log_predict,new_test$Survived)
> perf <- performance(pr,measure = "tpr",x.measure = "fpr") 
> plot(perf) > auc(new_test$Survived,log_predict) #0.76343
```

![AUC roc plot logistic regression](http://blog.hackerearth.com/wp-content/uploads/2017/01/Rplot1.png)

Our AUC score is 0.763. As said above, in ROC plot, we always try to move up and top left corner. From this plot, we can interpret that the model is predicting more negative values incorrectly. To move up, let's increase our threshold value to 0.6 and check the model's performance.

```r
> log_predict <- predict(log_model,newdata = new_test,type = "response")
> log_predict <- ifelse(log_predict > 0.6,1,0)

> pr <- prediction(log_predict,new_test$Survived)
> perf <- performance(pr,measure = "tpr",x.measure = "fpr")
> plot(perf)
> auc(new_test$Survived,log_predict)` ` #0.8008
```

# Naïve Bayes Classifier

![](https://uc-r.github.io/public/images/analytics/naive_bayes/naive_bayes_icon.png)

The ***Naïve Bayes classifier*** is a simple probabilistic classifier which is based on Bayes theorem but with strong assumptions regarding independence. Historically, this technique became popular with applications in email filtering, spam detection, and document categorization. Although it is often outperformed by other techniques, and despite the naïve design and oversimplified assumptions, this classifier can perform well in many complex real-world problems. And since it is a resource efficient algorithm that is fast and scales well, it is definitely a machine learning algorithm to have in your toolkit.

(**installing naivebayes**)

![](/home/akuma/Screenshots/Cheese_Sun-05Apr20_12.24.png)

![](/home/akuma/Screenshots/Cheese_Sun-05Apr20_12.23.png)

### 

### Conclusion:

Henceforth, we have successfully understood the logistic regression and naive bayes.
