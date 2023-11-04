# Education ----

edu_app <- "data-raw/education_application.csv" |>
  readr::read_csv() |>
  janitor::clean_names() |>
  # removes columns that have only one value
  dplyr::select(-c(dataflow, last_update, unit, freq))

edu_app |>
  dplyr::filter(
    isced11 == "TOTAL", c_educ == "TOTAL", age == "Y15-74",
    geo == "EU27_2020", sex == "T"
  ) |>
  dplyr::group_by(effect) |>
  dplyr::summarise(n = sum(obs_value), .groups = "drop") |>
  dplyr::left_join(label_edu_effects, "effect")

# Reasons for migrating and change in skill level ----

edu_stats <- "data-raw/education.csv" |>
  readr::read_csv() |>
  janitor::clean_names() |>
  # removes columns that have only one value
  dplyr::select(-c(dataflow, last_update, unit, freq))

edu_stats |>
  dplyr::filter(
    geo == "EU27_2020", age == "Y15-74", sex == "T", change == "TOTAL",
    !is.na(obs_value), !reason %in% c("EDUC_TNG_RET_OTH", "TOTAL", "EMP")
  ) |>
  dplyr::group_by(reason) |>
  dplyr::summarise(n = sum(obs_value), .groups = "drop") |>
  dplyr::left_join(label_edu_reason, "reason")

# change in skill level
edu_stats |>
  dplyr::filter(
    geo == "EU27_2020", age == "Y15-74", sex == "T",
    !is.na(obs_value), reason == "TOTAL", change != "TOTAL"
  ) |>
  dplyr::group_by(change) |>
  dplyr::summarise(n = sum(obs_value), .groups = "drop") |>
  dplyr::left_join(label_edu_change, "change")

# change in skill level per reason
edu_stats |>
  dplyr::filter(
    geo == "EU27_2020", age == "Y15-74", sex == "T", !is.na(obs_value),
    change != "TOTAL", !reason %in% c("EDUC_TNG_RET_OTH", "TOTAL", "EMP")
  ) |>
  dplyr::group_by(change, reason) |>
  dplyr::summarise(n = sum(obs_value), .groups = "drop") |>
  dplyr::left_join(label_edu_change, "change") |>
  ggplot2::ggplot(ggplot2::aes(x = change, y = n)) +
  ggplot2::geom_col() +
  ggplot2::facet_wrap(~reason)

# Foreing-born population skills ----
# Foreign-born population by level of skills in the main host country language
# before migrating, sex, age, country of birth and educational attainment level

skills <- "data-raw/foreign_skill.csv" |>
  readr::read_csv() |>
  janitor::clean_names() |>
  dplyr::select(-c(dataflow, last_update, unit, freq, time_period))

skills |>
  dplyr::filter(
    !is.na(obs_value), lev_know != "TOTAL",
    isced11 == "TOTAL", sex == "T", geo == "EU27_2020",
  ) |>
  dplyr::group_by(lev_know) |>
  dplyr::summarise(n = sum(obs_value), .groups = "drop") |>
  dplyr::left_join(label_skills, "lev_know") |>
  dplyr::arrange(dplyr::desc(n)) |>
  dplyr::filter(!lev_know %in% c("NRP", "TYNG_SPK")) |>
  janitor::adorn_percentages("col") |>
  janitor::adorn_pct_formatting() |>
  dplyr::transmute(
    level = label, `%` = n,
    level = factor(level, levels = c("None or minimum", "Basic", "Intermediate", "Proficient", "Mother tongue"))
  ) |>
  dplyr::arrange(level)
