# create_analysis_data_advice.R
#
# What this file does:
#  - Cleans up raw advice data from LKRHI

# --- Load Libraries --- #
library(readxl)
library(dplyr)

# --- Load Data --- #
advice_df  <-
   read_xlsx("src/data/Final advice set (120 - 20x2x3).xlsx")

# --- Clean Data Up --- #
# clean up the variable names, select what we need for regression analysis
# -> We will merge to the subjects data for regression analysis
#
# Remark: We had to revisit authors code to learn what the variable DH6 was and how to use it
# in subsequent analysis

advice_clean <- 
    advice_df %>%
    rename(text_number = `text number (like in qualtrics)`,
           group = `Group/Treatment`) %>%
    janitor::clean_names() %>%
    select(text_number, group, source, grammarly, read) %>%
    filter(group != "DHA") %>%
    mutate(group_simple = if_else(group == "DH6", "Dishonest", "Honest"))

# --- Write dataset to file ---- #
# This is the data we use later
readr::write_csv(advice_clean, 
                 "out/data/analysis_data_advice.csv"
)
