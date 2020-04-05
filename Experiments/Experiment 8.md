# Experiment 8

### Aim:

Basic and Advanced Graphics in R

### Theory:

Graphics are important for conveying important features of the data.**R** includes at least three graphical systems, the standard **graphics** package, the **lattice** package for Trellis graphs. R has good graphical capabilities but there are some alternatives like gnuplot.

R provides the usual range of standard statistical plots, including scatterplots,
boxplots, histograms, barplots, piecharts, and basic 3D plots. 

They can be used to examine
    • Marginal distributions
    • Relationships between variables
    •Summary of very large data

Important complement to many statistical and
computational techniques.

### Graphics in R

* `plot()` is the main function for graphics. The arguments can be a single point such as 0 or c(.3,.7), a single vector, a pair of vectors or many other R objects.
* `par()` is another important function which defines the default settings for plots.
* There are many other plot functions which are specific to some tasks such as `hist()`, `boxplot()`, etc. Most of them take the same arguments as the `plot()` function.

```r
  N <- 10^2
  x1 <- rnorm(N) 
  x2 <- 1 + x1 + rnorm(N)
  plot(0) 
  plot(0,1) 
  plot(x1) 
  plot(x1,x2) # scatter plot x1 on the horizontal axis and x2 on the vertical axis
  plot(x2 ~ x1) # the same but using a formula (x2 as a function of x1)
```

![](/home/akuma/SoopaProject/R/Experiments/img/Cheese_Sun-05Apr20_10.34.png)

#### R Histograms

In this article, you’ll learn to use hist() function to create histograms in R programming with the help of numerous examples.

Histogram can be created using the `hist()` function in R programming language. This function takes in a [vector](https://www.datamentor.io/r-programming/vector "R vector") of values for which the histogram is plotted.

Let us use the built-in dataset `airquality` which hasDaily air quality measurements in New York, May to September 1973.-R documentation.

```r
 str(airquality)
 'data.frame':153 obs. of  6 variables:$ Ozone  : int  41 36 12 18 NA 28 23 19 8 NA ...$
Solar.R: int  190 118 149 313 NA NA 299 99 19 194 ...$
Wind   : num  7.4 8 12.6 11.5 14.3 14.9 8.6 13.8 20.1 8.6 ...$ 
Temp   : int  67 72 74 62 56 66 65 59 61 69 ...$
Month  : int  5 5 5 5 5 5 5 5 5 5 ...$
Day    : int  1 2 3 4 5 6 7 8 9 10 ...
```

# 

```r
Temperature <- airquality$Temphist(Temperature)
```

![Simple Histogram in R programming](https://cdn.datamentor.io/wp-content/uploads/2017/11/r-histogram.png)

##### Titles, legends and annotations

**Titles**
main gives the main title, sub the subtitle. They can be passed as argument of the plot() function or using the title() function. xlab the name of the x axis and ylab the name of the y axis.

```r
 plot(x1,x2, main = "Main title", sub = "sub title" , ylab = "Y axis", xlab = "X axis")
 plot(x1,x2 ,  ylab = "Y axis", xlab = "X axis")
 title(main = "Main title", sub = "sub title" )
```

![](/home/akuma/SoopaProject/R/Experiments/img/Cheese_Sun-05Apr20_10.38.png)

## Label

The easiest place to start when turning an exploratory graphic into an expository graphic is with good labels. You add labels with the `labs()` function. This example adds a plot title:

```r
ggplot(mpg, aes(displ, hwy)) +
  geom_point(aes(color = class)) +
  geom_smooth(se = FALSE) +
  labs(title = "Fuel efficiency generally decreases with engine size")
```

![](/home/akuma/SoopaProject/R/Experiments/img/Cheese_Sun-05Apr20_10.42.png)

It’s possible to use mathematical equations instead of text strings. Just switch `""` out for `quote()` and read about the available options in `?plotmath`:

```r
df <- tibble(
  x = runif(10),
  y = runif(10)
)
ggplot(df, aes(x, y)) +
  geom_point() +
  labs(
    x = quote(sum(x[i] ^ 2, i == 1, n)),
    y = quote(alpha + beta + frac(delta, theta))
  )
```

![](/home/akuma/SoopaProject/R/Experiments/img/Cheese_Sun-05Apr20_10.43.png)

## Annotations

In addition to labelling major components of your plot, it’s often useful to label individual observations or groups of observations. The first tool you have at your disposal is `geom_text()`. `geom_text()` is similar to `geom_point()`, but it has an additional aesthetic: `label`. This makes it possible to add textual labels to your plots.

There are two possible sources of labels. First, you might have a tibble that provides labels. The plot below isn’t terribly useful, but it illustrates a useful approach: pull out the most efficient car in each class with dplyr, and then label it on the plot:

```r
best_in_class <- mpg %>%
  group_by(class) %>%
  filter(row_number(desc(hwy)) == 1)

ggplot(mpg, aes(displ, hwy)) +
  geom_point(aes(colour = class)) +
  geom_text(aes(label = model), data = best_in_class)
```

![](/home/akuma/SoopaProject/R/Experiments/img/Cheese_Sun-05Apr20_10.44.png)

This is hard to read because the labels overlap with each other, and with the points. We can make things a little better by switching to `geom_label()` which draws a rectangle behind the text. We also use the `nudge_y` parameter to move the labels slightly above the corresponding points:

```r
ggplot(mpg, aes(displ, hwy)) +
  geom_point(aes(colour = class)) +
  geom_label(aes(label = model), data = best_in_class, nudge_y = 2, alpha = 0.5)
```

![](/home/akuma/SoopaProject/R/Experiments/img/Cheese_Sun-05Apr20_10.45.png)

### Axis ticks and legend keys

There are two primary arguments that affect the appearance of the ticks on the axes and the keys on the legend: `breaks` and `labels`. Breaks controls the position of the ticks, or the values associated with the keys. Labels controls the text label associated with each tick/key. The most common use of `breaks` is to override the default choice:

```r
ggplot(mpg, aes(displ, hwy)) +
  geom_point() +
  scale_y_continuous(breaks = seq(15, 40, by = 5))
```

![](/home/akuma/SoopaProject/R/Experiments/img/Cheese_Sun-05Apr20_10.47.png)

### Replacing a scale

Instead of just tweaking the details a little, you can instead replace the scale altogether. There are two types of scales you’re mostly likely to want to switch out: continuous position scales and colour scales. Fortunately, the same principles apply to all the other aesthetics, so once you’ve mastered position and colour, you’ll be able to quickly pick up other scale replacements.

It’s very useful to plot transformations of your variable. For example, as we’ve seen in diamond prices it’s easier to see the precise relationship between `carat` and `price` if we log transform them:

```r
ggplot(diamonds, aes(carat, price)) +
  geom_bin2d()
```

![](/home/akuma/Screenshots/Cheese_Sun-05Apr20_10.49.png)

## Saving your plots

There are two main ways to get your plots out of R and into your final write-up: `ggsave()` and knitr. `ggsave()` will save the most recent plot to disk:

```r
ggplot(mpg, aes(displ, hwy)) + geom_point()
```

![](https://d33wubrfki0l68.cloudfront.net/1eb071c46c5f1aae2ed63a51590c632864c9ae8b/37ba5/communicate-plots_files/figure-html/unnamed-chunk-32-1.png)

```r
ggsave("my-plot.pdf")
#> Saving 6 x 3.7 in image
```

### Figure sizing

The biggest challenge of graphics in R Markdown is getting your figures the right size and shape. There are five main options that control figure sizing: `fig.width`, `fig.height`, `fig.asp`, `out.width` and `out.height`. Image sizing is challenging because there are two sizes (the size of the figure created by R and the size at which it is inserted in the output document), and multiple ways of specifying the size (i.e., height, width, and aspect ratio: pick two of three).

I only ever use three of the five options:

* I find it most aesthetically pleasing for plots to have a consistent width. To enforce this, I set `fig.width = 6` (6") and `fig.asp = 0.618` (the golden ratio) in the defaults. Then in individual chunks, I only adjust `fig.asp`.

* I control the output size with `out.width` and set it to a percentage of the line width. I default to `out.width = "70%"` and `fig.align = "center"`. That give plots room to breathe, without taking up too much space.

* To put multiple plots in a single row I set the `out.width` to `50%` for two plots, `33%` for 3 plots, or `25%` to 4 plots, and set `fig.align = "default"`. Depending on what I’m trying to illustrate ( e.g. show data or show plot variations), I’ll also tweak `fig.width`, as discussed below.

If you find that you’re having to squint to read the text in your plot, you need to tweak `fig.width`. If `fig.width` is larger than the size the figure is rendered in the final doc, the text will be too small; if `fig.width` is smaller, the text will be too big. You’ll often need to do a little experimentation to figure out the right ratio between the `fig.width` and the eventual width in your document. To illustrate the principle, the following three plots have `fig.width` of 4, 6, and 8 respectively:

![](https://d33wubrfki0l68.cloudfront.net/bd3974800c17e2685b5ed94ee7bb5a9e55278027/2816f/communicate-plots_files/figure-html/unnamed-chunk-35-1.png)![](https://d33wubrfki0l68.cloudfront.net/1eb071c46c5f1aae2ed63a51590c632864c9ae8b/db96c/communicate-plots_files/figure-html/unnamed-chunk-36-1.png)![](https://d33wubrfki0l68.cloudfront.net/ae73d8ecda562ca276df2dd128056adde1a6d5cc/53884/communicate-plots_files/figure-html/unnamed-chunk-37-1.png)

### Conclusion:

Henceforth, we have successfully studied and explored plotting and graphs in R.
