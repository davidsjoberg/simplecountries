
# simplecountries

<!-- badges: start -->

<!-- badges: end -->

`simplecountries` is a simple R package that helps to convert
alternative country names to common English. It only has the function
`simple_country_name`. The main source is [this wikipedia
article](https://en.wikipedia.org/wiki/List_of_alternative_country_names).

``` r
remotes::install_github("davidsjoberg/simplecountries")
```

## Example

This is a basic example:

``` r
library(simplecountries)

x <- c("Czech", "Great Britain")
simple_country_name(x)
#> [1] "Czechia"        "United Kingdom"
```

## Use `countrycode` instead

Since `simplecountries` was made the mature package `countrycode` has
introduced the function `countryname` which does the same thing but is
probably better maintained. You probably want to you that package
instead. More info
[here](https://github.com/vincentarelbundock/countrycode)

-----

If there is alternative names missing from this function let me know\!
