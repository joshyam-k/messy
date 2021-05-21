
# messy

A package that attempts to remedy some of the difficulties of cleaning
data composed of survey inputs. often times when trying to lump or clean
up a categorical variable that was a survey input you’ll come across
things like “The United States”, “the united states”, or “THE UNITES
STATES”. It can be time consuming and frustrating to try to identify
each capitalization variant and not all of us are `stringr` masters. All
that `Messy` does is gives a nice way to automate the process of testing
for all capitalization variants in a variable.

The developmental version of the package can be installed through github
using

``` r
devtools::install_github("joshyam-k/messy")
```

## How to use the package

I envision the main function in the package, `messy::messy_string` to be
used inside of `dplyr::case_when` as follows.

Suppose we have the following data frame:

``` r
library(tibble)
library(dplyr)
```

    ## 
    ## Attaching package: 'dplyr'

    ## The following objects are masked from 'package:stats':
    ## 
    ##     filter, lag

    ## The following objects are masked from 'package:base':
    ## 
    ##     intersect, setdiff, setequal, union

``` r
library(messy)

survey <- tibble(
  country = c('The United States', "the United states", "United kingdom", "United Kingdom"),
  age = 24:27
)
```

We’d like to clean up our categorical variable and in this example we
could do it by hand, but in a more large scale case it would be nice to
use `messy::messy_string`

`messy_string` takes a string as an input and outputs capitalization
variants of that string. For example:

``` r
messy_string("the united states")
```

    ##  [1] "the united states" "the united States" "the United states"
    ##  [4] "the United States" "The united states" "The united States"
    ##  [7] "The United states" "The United States" "the united STATES"
    ## [10] "the UNITED states" "the UNITED STATES" "THE united states"
    ## [13] "THE united STATES" "THE UNITED states" "THE UNITED STATES"

This can be used directly inside of `case_when` for a much easier
cleaning process!

``` r
survey %>% 
  mutate(
    country_clean = case_when(
      country %in% messy_string("the united states") ~ "USA",
      country %in% messy_string("united kingdom") ~ "UK"
    )
  )
```

    ## # A tibble: 4 x 3
    ##   country             age country_clean
    ##   <chr>             <int> <chr>        
    ## 1 The United States    24 USA          
    ## 2 the United states    25 USA          
    ## 3 United kingdom       26 UK           
    ## 4 United Kingdom       27 UK
