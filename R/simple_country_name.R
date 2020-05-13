#' @title simple_country_name
#'
#' @description Translates a vector of country names to common English equivalent. If no match is found the element is returned.
#'
#' @param .x a character vector of country names
#'
#' @details Source for common english country names is R package `countrycode` and alternative country names from `countrycode` and Wikipedia: \url{"https://en.wikipedia.org/wiki/List_of_alternative_country_names"}.
#'
#' @examples
#'
#' x <- c("Czech", "Great Britain")
#' simple_country_name(x)
#'
#' @return a data frame
#'
#' @export

simple_country_name <- function(.x) {
  if(class(.x) != "character") stop("'.x' need to be character vector")
  .x <- tolower(.x)
  out <- lookup_table_simple_country_names[.x]
  out2 <- out[!is.na(.x)]
  out[is.na(out)] <- .x[is.na(out)]
  if(sum(is.na(out2)) != 0) {
    warning(paste0(
      sum(is.na(out2)),
      " unique entries failed to match. Return input. It/they were '",
      paste(unique(.x[is.na(out2)]), collapse = "', '"),
      "'"
      ))
  }
  as.character(out)
}

#' @title alternative_country_name
#'
#' @description Returns alternative names for a common English country name.
#'
#' @param .x a character vector of length one.
#'
#' @details Souce for common english country names and alternative country names: \url{"https://en.wikipedia.org/wiki/List_of_alternative_country_names"}.
#'
#' @examples
#'
#' alternative_country_name("United states")
#'
#' @return a data frame
#'
#' @export

alternative_country_name <- function(.x) {
  if(class(.x) != "character") stop("'.x' need to be character vector")
  if(length(.x) != 1) stop("'.x' need to be of length one")
  if(!tolower(.x) %in% tolower(country_names_df$simple)) stop("'.x'is not a common English country name")
  .x <- tolower(.x)

  .df <- country_names_df
  .df$simple <- tolower(.df$simple)
  .df[.df$simple == .x, 2][[1]]
}


