# Experiment 4

### Aim

To study programming constructs in R - loops and conditional executions. 

### Theory

In R programming, while loops are used to loop until a specific condition is met.

---

## Syntax of while loop

```
while (test_expression){statement}
```

Here, `test_expression` is evaluated and the body of the loop is entered if the result is `TRUE`.

The statements inside the loop are executed and the flow returns to evaluate the `test_expression` again.

This is repeated each time until `test_expression` evaluates to `FALSE`, in which case, the loop exits.

A for loop is used to iterate over a [vector in R programming](https://www.datamentor.io/r-programming/vector "R vectors").

## Syntax of for loop

```
for (val in sequence){statement}
```

Here, `sequence` is a vector and `val` takes on each of its value during the loop. In each iteration, `statement` is evaluated.

## Syntax of ifelse() function

```
ifelse(test_expression, x, y)
```

Here, `test_expression` must be a logical vector (or an [object](https://www.datamentor.io/r-programming/object-class-introduction "R object") that can be coerced to logical). The return value is a vector with the same length as `test_expression`.

This returned vector has element from `x` if the corresponding value of `test_expression` is `TRUE` or from `y` if the corresponding value of `test_expression` is `FALSE`.

This is to say, the `i-th` element of result will be `x[i]` if `test_expression[i]` is `TRUE` else it will take the value of `y[i]`.

The vectors `x` and `y` are recycled whenever necessary.

```
> a = c(5,7,2,9)> ifelse(a %% 2 == 0,"even","odd")[1] "odd"  "odd"  "even" "odd" 
```

Decision making is an important part of programming. This can be achieved in R programming using the conditional `if...else` statement.

---

## R if statement

The syntax of if statement is:

```
if (test_expression) {statement}
```

If the `test_expression` is `TRUE`, the statement gets executed. But if it’s `FALSE`, nothing happens.

Here, `test_expression` can be a logical or numeric vector, but only the first element is taken into consideration.

In the case of numeric vector, zero is taken as `FALSE`, rest as `TRUE`.



## if…else statement

The syntax of if…else statement is:

```
if (test_expression) {statement1} else {statement2}
```

The else part is optional and is only evaluated if `test_expression` is `FALSE`.

## if…else Ladder

The if…else ladder (if…else…if) statement allows you execute a block of code among more than 2 alternatives

The syntax of if…else statement is:

```
if ( test_expression1) {statement1} else if ( test_expression2) {statement2} else if ( test_expression3) {statement3} else {statement4}
```



#### Screenshot:

![](/home/akuma/SoopaProject/R/Experiments/img/Cheese_Sat-04Apr20_19.37.png)



#### Conclusion

Henceforth, we have successfully studied conditionals and looping in R.
