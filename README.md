
# messy

A package that attempts to remedy some of the difficulties of cleaning
data composed of survey inputs. Often times when trying to lump or clean
up a categorical variable that was a survey input you’ll come across
things like “The United States”, “the united states”, or “THE UNITES
STATES”. It can be time consuming and frustrating to try to identify
each capitalization and punctuation variant and not all of us are
`stringr` masters. All that `Messy` does is gives a nice way to automate
the process of testing for a lot of capitalization and punctuation
variants in a variable.

The developmental version of the package can be installed through github
using:

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
library(messy)

survey <- tibble(
  country = c('The United States', "the United states", "the United-kingdom", "The United Kingdom"),
  ages = 24:27
)
```

We’d like to clean up our categorical variable and in this example we
could do it by hand, but in a more large scale case it could get very
tedious.

`messy_string` takes a string as an input and outputs capitalization and
punctuation variants of that string. The function is most useful when
used on a string that contains varying punctuation choices.

``` r
messy_string("the united-kingdom")
```

    ##  [1] "the united kingdom" "the united Kingdom" "the United kingdom"
    ##  [4] "the United Kingdom" "The united kingdom" "The united Kingdom"
    ##  [7] "The United kingdom" "The United Kingdom" "the united KINGDOM"
    ## [10] "the UNITED kingdom" "the UNITED KINGDOM" "THE united kingdom"
    ## [13] "THE united KINGDOM" "THE UNITED kingdom" "THE UNITED KINGDOM"
    ## [16] "the united-kingdom" "the united-Kingdom" "the United-kingdom"
    ## [19] "the United-Kingdom" "The united-kingdom" "The united-Kingdom"
    ## [22] "The United-kingdom" "The United-Kingdom" "the united-KINGDOM"
    ## [25] "the UNITED-kingdom" "the UNITED-KINGDOM" "THE united-kingdom"
    ## [28] "THE united-KINGDOM" "THE UNITED-kingdom" "THE UNITED-KINGDOM"

As you can see, when inputting a string with some type of punctuation
the output contains capitalization variants both with and without the
punctuation\! Thus when using the function to deal with punctuation
variety you should always input the string with as much punctuation as
possible.

The function can then be used directly inside of `case_when` for a much
easier cleaning process\!

``` r
survey %>% 
  mutate(
    country_clean = case_when(
      country %in% messy_string("the united states") ~ "USA",
      country %in% messy_string("united-kingdom") ~ "UK"
    )
  )
```

    ## # A tibble: 4 x 3
    ##   country             ages country_clean
    ##   <chr>              <int> <chr>        
    ## 1 The United States     24 USA          
    ## 2 the United states     25 USA          
    ## 3 the United-kingdom    26 <NA>         
    ## 4 The United Kingdom    27 <NA>

One final note is that every problem that you could solve with `messy`
could also be done with `stringr` and regular expressions. I wrote this
package fully aware of this fact, and acknowledge that there will be a
lot of places where this package is far less usefull or elegant than a
`stringr` approach. Nonetheless, `messy` provides a way to perhaps more
intuitively try to deal with all the messiness of survey inputted data.
