#' @title messy_string
#'
#' @description Generate a vector of capitalization variants of a string
#'
#' @param string A string for which you would like to generate capitalization variants
#'
#' @return A vector of strings
#' @examples
#' string <- "United States'
#' messy_string(string)
#' @export
#' @importFrom rlang .data

messy_string <- function(string) {

  # separate string into its individual words

  words <- stringr::str_to_lower(stringr::str_split(string, " ")[[1]])

  # create bistrings

  n <- length(words)

  binary_tibble <- tibble::as_tibble(binary_strings(n), .name_repair = "unique")

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

  final_phrases <- rbind(first_letter_cap, full_word_cap) %>%
    dplyr::distinct(.keep_all = T)

  # turn our dataframe into a vector where each object is a string

  unlist(final_phrases, use.names = F)

}
