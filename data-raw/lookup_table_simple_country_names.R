library(rvest)
library(dplyr)
library(tidyr)
library(stringr)
options(stringsAsFactors = F)

url <- "https://en.wikipedia.org/wiki/List_of_alternative_country_names"

country_names_df <- url %>%
  read_html() %>%
  html_nodes("table") %>%
  html_table() %>%
  bind_rows() %>%
  as_tibble()

country_names_df <- country_names_df %>%
  rename(simple = 1,
         alt_names = 2) %>%
  mutate_all(~.x %>%
               str_remove_all("\\([^)]*\\)")) %>%
  separate_rows(alt_names, sep = " , |, ") %>%
  mutate_all(str_trim)

country_names_df <- country_names_df %>%
  distinct() %>%
  group_by(alt_names) %>%
  filter(n() == 1) %>%
  ungroup()

# Add more alternative names below by adding another add_row
country_names_df <- country_names_df %>%
  add_row(alt_names = "Czech",
          simple    = "Czechia")

country_names_df <- country_names_df %>%
  mutate(alt_names = str_to_lower(alt_names))

# Fix country names if conflict with english name in countrycode data set (which is dominant)
country_names_df <- country_names_df %>%
  mutate(simple = case_when(
    simple == "The Bahamas" ~ "Bahamas",
    simple == "Bosnia and Herzegovina" ~ "Bosnia & Herzegovina",
    simple == "Côte d'Ivoire" ~ "Côte d’Ivoire",
    simple == "Netherlands[2]" ~ "Netherlands",
    simple == "Oman[3]" ~ "Oman",
    simple == "Trinidad and Tobago" ~ "Trinidad & Tobago",
    simple == "Saint Kitts and Nevis" ~ "St. Kitts & Nevis",
    simple == "Saint Vincent and the Grenadines" ~ "St. Vincent & Grenadines",
    simple == "Czech Republic" ~ "Czechia",
    simple == "Democratic Republic of Congo" ~ "Congo - Kinshasa",
    simple == "Republic of the Congo" ~ "Congo - Brazzaville",
    simple == "Myanmar" ~ "Myanmar (Burma)",
    simple == "Palestine" ~ "Palestinian Territories",
    simple == "Eswatini" ~ "Swaziland",
    T ~ simple
  ))

# Create lookup from package countrycode with alternative name
country_names_df_country_code <- countrycode::codelist %>%
  select(country.name.en, country.name.de, cow.name, ecb.name, eurostat.name, fao.name, fips, fips.name, ioc.name, iso.name.en, iso.name.fr, iso2c, iso3c,
         un.name.ar, un.name.en, un.name.es, un.name.fr, un.name.ru, un.name.zh, unpd.name, contains("cldr.name.")) %>%
  pivot_longer(-country.name.en) %>%
  transmute(country.name.en,
            value = str_to_lower(value)) %>%
  drop_na() %>%
  rename(simple = 1,
         alt_names = 2) %>%
  distinct() %>%
  mutate(alt_names = str_trim(alt_names)) %>%
  group_by(alt_names) %>%
  filter(n() == 1) %>%
  ungroup()

# Add together wikipedia alt names and country code names
country_names_df <- bind_rows(
  country_names_df,
  country_names_df_country_code
)

# Add simple name to alt name so it matches on itself
country_names_df <- bind_rows(
  country_names_df,
  tibble(simple = country_names_df$simple %>% unique(),
         alt_names = str_to_lower(simple))
) %>%
  distinct() %>%
  arrange(simple)

lookup_table_simple_country_names <- country_names_df$simple
names(lookup_table_simple_country_names) <- country_names_df$alt_names
usethis::use_data(lookup_table_simple_country_names, country_names_df, internal = TRUE, overwrite = T)
