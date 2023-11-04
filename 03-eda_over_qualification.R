# Over-qualification ----
# data from 2014

over_quali <- "data-raw/over_qualification.csv" |>
  readr::read_csv() |>
  janitor::clean_names() |>
  # removes columns that have only one value
  dplyr::select(-c(dataflow, last_update, unit, freq))

# higher education -> tend to self-declare as over-qualified
over_quali |>
  dplyr::filter(age == "Y15-64", sex == "T", mgstatus == "TOTAL", !is.na(obs_value)) |>
  dplyr::group_by(isced11) |>
  dplyr::summarise(mean = mean(obs_value))

# women declare themselves more often as over-qualified than men
over_quali |>
  dplyr::filter(age == "Y15-64", mgstatus == "TOTAL", !is.na(obs_value), isced11 == "TOTAL") |>
  dplyr::group_by(sex) |>
  dplyr::summarise(mean = mean(obs_value))

# there is little difference between men and women in ED02
over_quali |>
  dplyr::filter(age == "Y15-64", mgstatus == "TOTAL", !is.na(obs_value), sex != "T") |>
  dplyr::group_by(isced11, sex) |>
  dplyr::summarise(mean = mean(obs_value), .groups = "drop") |>
  ggplot2::ggplot(ggplot2::aes(x = sex, y = mean)) +
  ggplot2::geom_col() +
  ggplot2::facet_wrap(~isced11)

# young people tend to self-declare as over-qualified
over_quali |>
  dplyr::filter(isced11 == "TOTAL", sex == "T", mgstatus == "TOTAL", !is.na(obs_value)) |>
  dplyr::group_by(age) |>
  dplyr::summarise(mean = mean(obs_value))
