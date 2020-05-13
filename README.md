
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
#> [1] "Czech Republic" "United Kingdom"
```

-----

If there is alternative names missing from this function let me know\!
