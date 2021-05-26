#' @title messy_string
#'
#' @description Generate a vector of capitalization variants of a string
#'
#' @param string A string for which you would like to generate capitalization variants
#'
#' @return A vector of strings
#' @examples
#' string <- "United States"
#' messy_string(string)
#' @export
#' @importFrom rlang .data

new_strings <- function(string) {

  # separate string into its individual words

  if (stringr::str_detect(string, "-")) {

    string <- stringr::str_replace_all(string, "-", " - ")

  }

  words <- stringr::str_to_lower(stringr::str_split(string, " ")[[1]])

  # create bistrings

  n <- length(words)

  binary_tibble <- as.data.frame(binary_strings(n), .name_repair = "unique")

  # create placeholder tibbles to be filled with modified strings

  full_word_cap <- binary_tibble
  first_letter_cap <- binary_tibble

  for (row in 1:nrow(binary_tibble)) {

    for (col in 1:n) {

      if (binary_tibble[row, col] == '0') {

        first_letter_cap[row, col] <- words[col]
        full_word_cap[row, col] <- words[col]

      } else {

        first_letter_cap[row, col] <-
          paste0(stringr::str_to_upper(stringr::str_sub(words[col], 1, 1)), stringr::str_sub(words[col], 2, -1))

        full_word_cap[row, col] <- stringr::str_to_upper(words[col])

      }

    }
  }

  # right now each word is a different column so we'd like to the unite the columns with a space as the separator

  first_letter_cap <- tidyr::unite(first_letter_cap, phrase, 1:ncol(first_letter_cap), sep = " ")
  full_word_cap <- tidyr::unite(full_word_cap, phrase, 1:ncol(full_word_cap), sep = " ")

  # remove any duplicates

  final_phrases <- dplyr::distinct(rbind(first_letter_cap, full_word_cap), .keep_all = T)

  if (stringr::str_detect(string, "'")) {

    to_add1 <- apostrophe_rm(final_phrases)

    final_phrases <- rbind(final_phrases, to_add1)

  }


  if (stringr::str_detect(string, "\\.")) {

    to_add2 <- period_rm(final_phrases)

    final_phrases <- rbind(final_phrases, to_add2)

  }

  if (stringr::str_detect(string, ",")) {


    to_add3 <- comma_rm(final_phrases)

    final_phrases <- rbind(final_phrases, to_add3)

  }

  if (stringr::str_detect(string, "!")) {

    to_add4 <- exclamation_rm(final_phrases)

    final_phrases <- rbind(final_phrases, to_add4)

  }

  # turn our dataframe into a vector where each object is a string

  unlist(final_phrases, use.names = F)

}


messy_string <- function(string) {

  if (stringr::str_detect(string, "-")) {

    loc <- stringr::str_locate(string, "-")[[1]]

    string2 <- stringr::str_replace_all(string, "-", " ")

    final_phrases <- new_strings(string2)
    final_phrases2 <- new_strings(string2)

    hyphen_add <- function(x, loc) {

      stringr::str_sub(x, loc, loc) <- "-"; x

    }

    final_phrases2 <- purrr::map_chr(final_phrases2, ~hyphen_add(.x, loc))

    #stringr::str_replace(.x, , "-")

    ret <- c(final_phrases, final_phrases2)

  } else {

    ret <- new_strings(string)

  }

  ret

}

