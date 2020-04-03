income <- read.csv('adult.csv',na.strings = c('','?'))
str(income)
summary(income)
sapply(income,function(x) sum(is.na(x)))
sapply(income, function(x) length(unique(x)))
library(Amelia)
missmap(income, main = "Missing values vs observed")
table (complete.cases (income))
income <- income[complete.cases(income),]
library(ggplot2)
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
#cuz final weight shows no variation wrt income
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
#categorical variable exploration and plotting
income$native.country <- NULL
#for simplification and saving myself from headache I prefer to not conduct my study as per the countries
income$income = as.factor(ifelse(income$income==income$income[1],0,1))
#basically if >50k it will be set to 1 else to 0
summary(income)
str(income)
#len(income)
count(income)
train <- income[1:22793,]
test <- income[22793:32561,]
model <-glm(income ~.,family=binomial(link='logit'),data=train)
summary(model)
anova(model,test="Chisq")
fitted.results <- predict(model,newdata=test,type='response')
fitted.results <- ifelse(fitted.results > 0.5,1,0)
misClasificError <- mean(fitted.results != test$income)
print(paste('Accuracy :',1-misClasificError))

