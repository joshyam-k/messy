
binary_strings <- function(n, digits = c('0','1')) {

  if (n <= 0) return(matrix(0,0,0))
  if (n == 1) return(matrix(digits, 2))

  x <- binary_strings(n - 1)

  rbind(cbind(digits[1], x), cbind(digits[2], x))

}


apostrophe_rm <- function(df) {

  new <- df

  for (i in 1:nrow(new)) {
    for (j in 1:ncol(new)) {

      new[i, j] <- stringr::str_remove_all(new[[i,j]], "'")

    }
  }

  new

}

hyphen_rm <- function(df) {

  new <- df

  for (i in 1:nrow(new)) {
    for (j in 1:ncol(new)) {

      new[i, j] <- stringr::str_remove_all(new[[i,j]], "-")

    }
  }

  new

}
