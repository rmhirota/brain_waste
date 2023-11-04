# Employment and language

# General context: Employment rates ----

empl_rates <- "data-raw/employment_rates.csv" |>
  readr::read_csv() |>
  janitor::clean_names() |>
  # removes columns that have only one value
  dplyr::select(-c(dataflow, last_update, unit, freq))

# how have employment rates been in the last years for foreigners?

empl_rates |>
  dplyr::filter(
    sex == "T", age == "Y_GE15", geo == "EU27_2020", stringr::str_detect(c_birth, "FOR")
  ) |>
  dplyr::group_by(time_period) |>
  dplyr::summarise(n = sum(obs_value), .groups = "drop") |>
  ggplot2::ggplot(ggplot2::aes(x = time_period, y = n)) +
  ggplot2::geom_line() +
  ggplot2::geom_smooth(method = "lm", formula = y ~ x, se = FALSE)

# is there any countries where the trend is different?
# try to identify countries where employment rate is decreasing (simple lm)

empl_rates |>
  dplyr::filter(
    sex == "T", age == "Y_GE15", stringr::str_detect(c_birth, "FOR"),
    !geo %in% c("EU27_2020", "EA20"), !is.na(obs_value)
  ) |>
  dplyr::group_by(geo, time_period) |>
  dplyr::summarise(n = sum(obs_value), .groups = "drop") |>
  ggplot2::ggplot(ggplot2::aes(x = time_period, y = n, group = geo)) +
  ggplot2::geom_line() +
  ggplot2::geom_smooth(method = "lm", formula = y ~ x, se = FALSE) +
  ggplot2::facet_wrap(~geo)

slope_lm <- function(df) {
  fit <- lm(df$n ~ df$time_period)
  output <- tibble::tibble(geo = df$geo[[1]], slope = fit$coefficients[[2]])
  return(output)
}

empl_rates |>
  dplyr::filter(
    sex == "T", age == "Y_GE15", stringr::str_detect(c_birth, "FOR"),
    !geo %in% c("EU27_2020", "EA20"), !is.na(obs_value)
  ) |>
  dplyr::group_by(geo, time_period) |>
  dplyr::summarise(n = sum(obs_value), .groups = "drop") |>
  dplyr::group_split(geo) |>
  purrr::map_vec(slope_lm) |>
  dplyr::arrange(slope) |>
  dplyr::left_join(label_geo, "geo")

# Reason for discrimination ----
# Employment by reason for discrimination in the current job, sex, age, country
# of birth and educational attainment level

empl_discrimin <- "data-raw/employment_discrimination.csv" |>
  readr::read_csv() |>
  janitor::clean_names() |>
  dplyr::select(-c(dataflow, last_update, unit, freq))

# Most common reason (as of 2021)

empl_discrimin |>
  dplyr::filter(
    isced11 == "TOTAL", c_birth == "TOTAL", sex == "T", age == "Y15-74",
    geo == "EU27_2020", !reason %in% c("TOTAL", "NONE", "NRP", "AGFOD_OTH")
  ) |>
  dplyr::group_by(reason) |>
  dplyr::summarise(n = sum(obs_value)) |>
  dplyr::arrange(dplyr::desc(n)) |>
  dplyr::left_join(label_discrim_reason, "reason")

# Difference per gender
# As expected, women are more discriminated by gender when compared to men

empl_discrimin |>
  dplyr::filter(
    isced11 == "TOTAL", c_birth == "TOTAL", sex != "T", age == "Y15-74",
    geo == "EU27_2020", !reason %in% c("TOTAL", "NONE", "NRP", "AGFOD_OTH")
  ) |>
  dplyr::group_by(sex, reason) |>
  dplyr::summarise(n = sum(obs_value), .groups = "drop") |>
  dplyr::arrange(dplyr::desc(n)) |>
  dplyr::left_join(label_discrim_reason, "reason") |>
  ggplot2::ggplot(ggplot2::aes(x = reason, y = n)) +
  ggplot2::geom_col() +
  ggplot2::facet_wrap(~sex)

# Difference per age
empl_discrimin |>
  dplyr::filter(
    isced11 == "TOTAL", c_birth == "TOTAL", sex == "T",
    geo == "EU27_2020", !reason %in% c("TOTAL", "NONE", "NRP", "AGFOD_OTH")
  ) |>
  dplyr::group_by(age, sex, reason) |>
  dplyr::summarise(n = sum(obs_value), .groups = "drop") |>
  dplyr::arrange(dplyr::desc(n)) |>
  dplyr::left_join(label_discrim_reason, "reason") |>
  ggplot2::ggplot(ggplot2::aes(x = reason, y = n)) +
  ggplot2::geom_col() +
  ggplot2::facet_wrap(~age)

# Difference per country

empl_discrimin |>
  dplyr::filter(
    isced11 == "TOTAL", c_birth == "TOTAL", sex == "T", age == "Y15-74",
    !geo %in% c("EU27_2020", "EA20"), !reason %in% c("TOTAL", "NONE", "NRP", "AGFOD_OTH")
  ) |>
  dplyr::group_by(geo, reason) |>
  dplyr::summarise(n = sum(obs_value), .groups = "drop") |>
  dplyr::arrange(dplyr::desc(n)) |>
  dplyr::left_join(label_discrim_reason, "reason") |>
  ggplot2::ggplot(ggplot2::aes(x = reason, y = n)) +
  ggplot2::geom_col() +
  ggplot2::facet_wrap(~geo)

# Austria and the Netherlands are countries where foreign origin is a common
# reason for discrimination (in comparison to other reasons)

empl_discrimin |>
  dplyr::filter(
    isced11 == "TOTAL", c_birth == "TOTAL", sex == "T", age == "Y15-74",
    !geo %in% c("EU27_2020", "EA20"), !reason %in% c("TOTAL", "NONE", "NRP", "AGFOD_OTH")
  ) |>
  dplyr::group_by(geo, reason) |>
  dplyr::summarise(n = sum(obs_value), .groups = "drop") |>
  dplyr::group_by(geo) |>
  dplyr::slice_max(n) |>
  dplyr::ungroup() |>
  dplyr::left_join(label_discrim_reason, "reason") |>
  dplyr::left_join(label_geo, "geo") |>
  dplyr::arrange(label.x)

# Main obstacle for foreign-born population ----
# Foreign-born population by main obstacle to get a suitable job, sex, age,
# country of birth and educational attainment level

obstacle <- "data-raw/foreign_obstacle.csv" |>
  readr::read_csv() |>
  janitor::clean_names() |>
  dplyr::select(-c(dataflow, last_update, unit, freq, time_period))

obstacle |>
  dplyr::filter(
    !is.na(obs_value), !barrier %in% c("TOTAL", "NRP", "LQCFOJ_OTH"),
    isced11 == "TOTAL", sex == "T", geo == "EU27_2020",
  ) |>
  dplyr::group_by(barrier) |>
  dplyr::summarise(n = sum(obs_value), .groups = "drop") |>
  dplyr::left_join(label_barrier, "barrier") |>
  dplyr::arrange(dplyr::desc(n))

# Main obstacles per country

obstacle |>
  dplyr::filter(
    !is.na(obs_value), !barrier %in% c("TOTAL", "NRP", "LQCFOJ_OTH", "NONE", "NVR_WRK"),
    isced11 == "TOTAL", sex == "T", !geo %in% c("EU27_2020", "EA20")
  ) |>
  dplyr::group_by(geo, barrier) |>
  dplyr::summarise(n = sum(obs_value), .groups = "drop") |>
  dplyr::left_join(label_barrier, "barrier") |>
  dplyr::group_by(geo) |>
  dplyr::slice_max(n) |>
  dplyr::ungroup() |>
  # dplyr::count(label)
  print(n = 30)

obstacle |>
  dplyr::filter(
    !is.na(obs_value), !barrier %in% c("TOTAL", "NRP", "LQCFOJ_OTH", "NONE"),
    isced11 == "TOTAL", sex == "T", !geo %in% c("EU27_2020", "EA20")
  ) |>
  dplyr::group_by(geo, barrier) |>
  dplyr::summarise(n = sum(obs_value), .groups = "drop") |>
  dplyr::left_join(label_barrier, "barrier") |>
  ggplot2::ggplot(ggplot2::aes(y = barrier, x = n)) +
  ggplot2::geom_col() +
  ggplot2::facet_wrap(~geo)

obstacle |>
  dplyr::filter(
    !is.na(obs_value), !barrier %in% c("TOTAL", "NRP", "LQCFOJ_OTH", "NONE"),
    isced11 == "TOTAL", sex == "T", !geo %in% c("EU27_2020", "EA20")
  ) |>
  dplyr::group_by(geo, barrier) |>
  dplyr::summarise(n = sum(obs_value), .groups = "drop") |>
  dplyr::left_join(label_barrier, "barrier") |>
  dplyr::group_by(geo) |>
  dplyr::slice_max(n) |>
  dplyr::arrange(barrier) |>
  print( n = 30)

# Main obstacle for women and men
obstacle |>
  dplyr::filter(
    !is.na(obs_value), !barrier %in% c("TOTAL", "NRP", "LQCFOJ_OTH", "NONE", "NVR_WRK"),
    isced11 == "TOTAL", sex != "T", geo == "EU27_2020"
  ) |>
  dplyr::group_by(sex, barrier) |>
  dplyr::summarise(n = sum(obs_value), .groups = "drop") |>
  dplyr::left_join(label_barrier, "barrier") |>
  ggplot2::ggplot(ggplot2::aes(x = sex, y = n)) +
  ggplot2::geom_col() +
  ggplot2::facet_wrap(~barrier)


# Employment satisfaction ----

satisf_occup <- "data-raw/satisfaction_occupation.csv" |>
  readr::read_csv() |>
  janitor::clean_names() |>
  # removes columns that have only one value
  dplyr::select(-c(dataflow, last_update, unit, freq))

# satisfaction level per gender
satisf_occup |>
  dplyr::filter(
    citizen == "TOTAL", age == "Y15-74", sex != "T", geo == "EU27_2020",
    !is.na(obs_value), lev_satis != "TOTAL"
  ) |>
  dplyr::group_by(sex, lev_satis) |>
  dplyr::summarise(n = sum(obs_value), .groups = "drop") |>
  ggplot2::ggplot(ggplot2::aes(x = lev_satis, y = n)) +
  ggplot2::geom_col() +
  ggplot2::facet_wrap(~sex)

# satisfaction level per age
satisf_occup |>
  dplyr::filter(
    citizen == "TOTAL", sex == "T", geo == "EU27_2020",
    !is.na(obs_value), lev_satis != "TOTAL"
  ) |>
  dplyr::group_by(age, lev_satis) |>
  dplyr::summarise(n = sum(obs_value), .groups = "drop") |>
  ggplot2::ggplot(ggplot2::aes(x = lev_satis, y = n)) +
  ggplot2::geom_col() +
  ggplot2::facet_wrap(~age)


# satisfaction level per occupation
satisf_occup |>
  dplyr::filter(
    citizen == "TOTAL", age == "Y15-74", sex == "T", geo == "EU27_2020",
    !is.na(obs_value), lev_satis != "TOTAL"
  ) |>
  dplyr::mutate(lev_satis = factor(lev_satis, labels = c("HIGH", "MED", "LOW", "NONE", "NRP"))) |>
  dplyr::group_by(isco08, lev_satis) |>
  dplyr::summarise(n = sum(obs_value), .groups = "drop") |>
  dplyr::left_join(label_isco08, "isco08") |>
  tidyr::pivot_wider(names_from = lev_satis, values_from = n, names_sort = TRUE) |>
  janitor::adorn_percentages() |>
  janitor::adorn_pct_formatting()

# satisfaction level per country
satisf_occup |>
  dplyr::filter(
    citizen == "TOTAL", age == "Y15-74", sex == "T", isco08 == "TOTAL",
    !geo %in% c("EU27_2020", "EA20"), !is.na(obs_value), lev_satis != "TOTAL"
  ) |>
  dplyr::mutate(lev_satis = factor(lev_satis, labels = c("HIGH", "MED", "LOW", "NONE", "NRP"))) |>
  dplyr::group_by(geo, lev_satis) |>
  dplyr::summarise(n = sum(obs_value), .groups = "drop") |>
  dplyr::left_join(label_geo, "geo") |>
  tidyr::pivot_wider(names_from = lev_satis, values_from = n, names_sort = TRUE) |>
  janitor::adorn_percentages() |>
  dplyr::arrange(dplyr::desc(LOW)) |>
  janitor::adorn_pct_formatting()

# occupations with lowest level of satisfaction per country
satisf_occup |>
  dplyr::filter(
    citizen == "TOTAL", age == "Y15-74", sex == "T", isco08 != "TOTAL",
    !geo %in% c("EU27_2020", "EA20"), !is.na(obs_value), lev_satis == "LOW"
  ) |>
  dplyr::group_by(geo, isco08) |>
  dplyr::summarise(n = sum(obs_value), .groups = "drop") |>
  dplyr::group_by(geo) |>
  dplyr::slice_max(n) |>
  dplyr::ungroup() |>
  dplyr::left_join(label_geo, "geo") |>
  dplyr::left_join(label_isco08, "isco08") |>
  dplyr::transmute(geo, country = label.x, isco08, occupation = label.y, n)
