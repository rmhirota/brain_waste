# c_birth: country/region of birth ----

label_c_birth <- tibble::tribble(
  ~c_birth, ~label,
  "EU27_2020",      "European Union - 27 countries (from 2020)",
  "EU27_2020_FOR",  "EU27 countries (from 2020) except reporting country",
  "NEU27_2020_FOR", "Non-EU27 countries (from 2020) nor reporting country",
  "FOR",            "Foreign country",
  "NAT",            "Reporting country"
)
readr::write_rds(label_c_birth, "data-raw/tbl_labels/label_c_birth.rds")


# Geopolitical entity (reporting) ----

label_geo <- tibble::tribble(
  ~label, ~geo,
  "European Union - 27 countries (from 2020)", "EU27_2020",
  "Euro area – 20 countries (from 2023)", "EA20",
  "Belgium", "BE",
  "Bulgaria", "BG",
  "Czechia", "CZ",
  "Denmark", "DK",
  "Germany", "DE",
  "Estonia", "EE",
  "Ireland", "IE",
  "Greece", "EL",
  "Spain", "ES",
  "France", "FR",
  "Croatia", "HR",
  "Italy", "IT",
  "Cyprus", "CY",
  "Latvia", "LV",
  "Lithuania", "LT",
  "Luxembourg", "LU",
  "Hungary", "HU",
  "Malta", "MT",
  "Netherlands", "NL",
  "Austria", "AT",
  "Poland", "PL",
  "Portugal", "PT",
  "Romania", "RO",
  "Slovenia", "SI",
  "Slovakia", "SK",
  "Finland", "FI",
  "Sweden", "SE",
  "Iceland", "IS",
  "Norway", "NO",
  "Switzerland", "CH",
  "United Kingdom", "UK",
  "Montenegro", "ME",
  "North Macedonia", "MK",
  "Serbia", "RS",
  "Türkiye", "TR"
)
readr::write_rds(label_geo, "data-raw/tbl_labels/label_geo.rds")


# Age class ----

label_age <- tibble::tribble(
  ~label, ~age,
  "From 15 to 19 years", "Y15-19",
  "From 15 to 24 years", "Y15-24",
  "From 15 to 29 years", "Y15-29",
  "From 15 to 39 years", "Y15-39",
  "From 15 to 59 years", "Y15-59",
  "From 15 to 64 years", "Y15-64",
  "From 15 to 74 years", "Y15-74",
  "15 years or over", "Y_GE15",
  "From 20 to 24 years", "Y20-24",
  "From 20 to 64 years", "Y20-64",
  "From 25 to 29 years", "Y25-29",
  "From 25 to 49 years", "Y25-49",
  "From 25 to 54 years", "Y25-54",
  "From 25 to 59 years", "Y25-59",
  "From 25 to 64 years", "Y25-64",
  "From 25 to 74 years", "Y25-74",
  "25 years or over", "Y_GE25",
  "From 30 to 34 years", "Y30-34",
  "From 35 to 39 years", "Y35-39",
  "From 40 to 44 years", "Y40-44",
  "From 40 to 59 years", "Y40-59",
  "From 40 to 64 years", "Y40-64",
  "From 45 to 49 years", "Y45-49",
  "From 50 to 54 years", "Y50-54",
  "From 50 to 59 years", "Y50-59",
  "From 50 to 64 years", "Y50-64",
  "From 50 to 74 years", "Y50-74",
  "50 years or over", "Y_GE50",
  "From 55 to 59 years", "Y55-59",
  "From 55 to 64 years", "Y55-64",
  "From 60 to 64 years", "Y60-64",
  "From 65 to 69 years", "Y65-69",
  "From 65 to 74 years", "Y65-74",
  "65 years or over", "Y_GE65",
  "From 70 to 74 years", "Y70-74",
  "75 years or over", "Y_GE75"
)
readr::write_rds(label_age, "data-raw/tbl_labels/label_age.rds")


label_discrim_reason <- tibble::tribble(
  ~label, ~reason,
  "Total", "TOTAL",
  "Age, gender, foreign origin, disability and other reason", "AGFOD_OTH",
  "Age", "AGE",
  "Gender", "GEND",
  "Foreign origin", "ORI_FOR",
  "Disability", "DIS",
  "None", "NONE",
  "Other reason", "OTH",
  "No response", "NRP",
)
readr::write_rds(label_discrim_reason, "data-raw/tbl_labels/label_discrim_reason.rds")


label_isced <- tibble::tribble(
  ~isced11, ~label,
  "ED0-2", "Early childhood education, Primary education, Lower secondary education",
  "ED3_4", "Upper secondary education, Post-secondary non-tertiary education",
  "ED5-8", "Short-cycle tertiary education, Bachelor’s or equivalent level, Master’s or equivalent level, Doctoral or equivalent level"
)
readr::write_rds(label_isced, "data-raw/tbl_labels/label_isced.rds")


label_barrier <- tibble::tribble(
  ~label, ~barrier,
  "Language skills, qualifications, citizenship, foreign origin, job and other barriers", "LQCFOJ_OTH",
  "Lack of language skills", "LLANG",
  "Lack of recognition of qualifications", "LREC_QLF",
  "Citizenship or residence permit", "CTZ_RPRM",
  "Discrimination due to foreign origin", "DCRIM_ORI_FOR",
  "No suitable job available", "NSJOB_AVL",
  "Never sought work or never worked", "NVR_WRK",
  "Other", "OTH",
  "None", "NONE"
)
readr::write_rds(label_barrier, "data-raw/tbl_labels/label_barrier.rds")


label_skills <- tibble::tribble(
  ~label, ~lev_know,
  "Too young to speak", "TYNG_SPK",
  "Mother tongue", "MOT",
  "Proficient", "PROF",
  "Intermediate", "INT",
  "Basic", "BASIC",
  "None or minimum", "NONE_MIN",
  "No response", "NRP",
)
readr::write_rds(label_skills, "data-raw/tbl_labels/label_skills.rds")

label_edu_effects <- tibble::tribble(
  ~label, ~effect,
  "Formal qualification recognised", "FQLF_REC",
  "Formal qualification not recognised", "FQLF_NREC",
  "Procedure under way or outcome pending", "PROC_UW",
  "Not applicable - did not apply for recognition", "NAP_NAPLD",
  "No response", "NRP",
)
readr::write_rds(label_edu_effects, "data-raw/tbl_labels/label_edu_effects.rds")

label_edu_change <- tibble::tribble(
  ~label, ~change,
  "Increase", "INCR",
  "Same", "SAME",
  "Decrease", "DECR",
  "Did not work", "NWRK",
  "No response", "NRP"
)
readr::write_rds(label_edu_change, "data-raw/tbl_labels/label_edu_change.rds")

label_edu_reason <- tibble::tribble(
  ~label, ~reason,
  "Total", "TOTAL",
  "Family reasons", "FAM",
  "Education or training, retirement or other reason", "EDUC_TNG_RET_OTH",
  "Education or training", "EDUC_TNG",
  "Employment - job found before migrating", "EMP_F_JOB",
  "Employment - no job found before migrating", "EMP_NF_JOB",
  "Employment reasons", "EMP",
  "Retirement", "RET",
  "International protection or asylum", "IPROT_ASY",
  "Other reason", "OTH",
  "No response", "NRP"
)
readr::write_rds(label_edu_reason, "data-raw/tbl_labels/label_edu_reason.rds")

label_citizen <- tibble::tribble(
  ~label, ~citizen,
  "EU27 countries (from 2020) except reporting country", "EU27_2020_FOR",
  "Non-EU27 countries (from 2020) nor reporting country", "NEU27_2020_FOR",
  "Foreign country", "FOR",
  "Reporting country", "NAT",
  "Stateless", "STLS",
  "Total", "TOTAL"
)
readr::write_rds(label_citizen, "data-raw/tbl_labels/label_citizen.rds")

label_isco08 <- tibble::tribble(
  ~label, ~isco08,
  "Total", "TOTAL",
  "Managers", "OC1",
  "Professionals", "OC2",
  "Technicians and associate professionals", "OC3",
  "Clerical support workers", "OC4",
  "Service and sales workers", "OC5",
  "Skilled agricultural, forestry and fishery workers", "OC6",
  "Craft and related trades workers", "OC7",
  "Plant and machine operators and assemblers", "OC8",
  "Elementary occupations", "OC9",
  "Armed forces occupations", "OC0",
  "No response", "NRP",
)
readr::write_rds(label_isco08, "data-raw/tbl_labels/label_isco08.rds")
