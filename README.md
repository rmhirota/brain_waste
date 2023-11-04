# Data Reporter candidate assignment -- Lighthouse Reports

This assignment was completed using `R` and `quarto`.

## Data used

The tables in `data-raw` were downloaded from
[Eurostat](https://ec.europa.eu/eurostat/databrowser) (and given friendlier
names). There are auxiliary tables in `data-raw/tbl_labels` created by the
script `make_labels.R` with the corresponding labels of variables in `.rds`,
which are read during the analysis and rendering of the Data Memo.

## Analysis

The following R files are used for exploratory data analysis of some of the
tables from Eurostat:

- `01-eda_employment.R`
- `02-eda_education.R`
- `03-eda_over_qualification.R`

## Data Memo

The Data Memo, along with follow up questions, editorial objectives and research question can be found both in PDF (`brain_waste.pdf`) and in HTML (`brain_waste.html`). Both files are rendered from `brain_waste.qmd`. To re-render them, use
```
quarto render brain_waste.qmd
```
in the terminal.

