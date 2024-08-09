# create_regression_data.R
#
# What this file does:
#   - Merges cleaned subject and advice data into one file
#     to be used in regression analysis
#

# --- Load libraries --- #
library(readr)
library(dplyr)

# --- Load Data --- #
subjects_clean <-
    read_csv("out/data/analysis_data_subjects.csv")

advice_clean <-
    read_csv("out/data/analysis_data_advice.csv")

# --- Merge subject data to advice data --- #
subjects_with_advice <-
    subjects_clean %>%
    left_join(advice_clean, by = c('text' = 'text_number',
                                  'source' = 'source',
                                  'moral' = 'group_simple')
    )

# --- Write output data --- #
write_csv(subjects_with_advice, 
          "out/data/analysis_data_subjects_with_advice.csv")
