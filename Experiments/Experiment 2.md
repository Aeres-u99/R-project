# Experiment 2

### Aim:

Basic functionality of R - Variables, basic arithmetics and help commands.

### Theory:

Every programming language has a syntax, definitely needs one as long as its not esoteric programming language like brainfuck, pikachu. Variables are basically the placeholders for user inputs and data, in R they have a very significant role as it allows us to keep an entire dataset (and refer to it) using variables.

Basic arithmetics and help commands enable us to get acquainted with the language itself.

#### Arithmetics and Basics:

The console is where you enter commands for **R** to execute *interactively*, meaning that the command is executed and the result is displayed as soon as you hit the `Enter` key. For example, at the command prompt `>`, type in `2+2` and hit `Enter`; you will see

```
2+2 
```

```
## [1] 4
```

The results from calculations can be stored in (*assigned to*) variables. For example:

```
a <- 2+2
```

**R** automatically creates the variable `a` and stores the result (4) in it, but by default doesn’t print anything. To ask **R** to print the value, just type the variable name by itself

```
a
```

```
## [1] 4
```

`print(a)` also works to print the value of a variable. By default, a variable created this way is a *vector* (an ordered list), and it is *numeric* because we gave **R** a number rather than (e.g.) a character string like `"pxqr"`; in this case `a` is a numeric vector of length 1;

You could also type

```
a <- 2+2; a
```

using a semicolon to put two or more commands on a single line. Conversely, you can break lines *anywhere that* **R** *can tell you haven’t finished your command* and **R** will give you a “continuation” prompt (`+`) to let you know that it doesn’t think you’re finished yet: try typing

```
a <- 3*(4+5)
```

```
x <- 5
y <- 2
z1 <- x*yz2 <- x/yz3 <- x^yz1; z2; z3
```

```
## [1] 10
```

```
## [1] 2.5
```

```
## [1] 25
```

#### Help system in R

**R** has a help system, although it is generally better for reminding you about syntax or details, and for giving cross-references, than for answering basic “how do I …?” questions.

* You can get help on an **R** function named `foo` by entering

```
?foo
```

or

```
help(foo)
```



#### Screenshots:

![](/home/akuma/.config/marktext/images/30bdf1f8e0169b5b02f81185f9386d040f184c2b.png)



#### Conclusion:

Henceforth, we have successfully studied the variables,assignments and help command in R.


