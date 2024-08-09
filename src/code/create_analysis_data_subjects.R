# create_analysis_data_subjects.R
#
# What this file does:
#  - Cleans up raw subjects data from LKRHI to create the data used in the 
#    final analysis and results presented in their EJ paper
#

# --- Load Libraries --- #
library(readxl)
library(dplyr)

# --- Load Data --- #
subject_df <- 
    read_xlsx("src/data/data.xlsx") %>% 
    janitor::clean_names()

#advice_df  <- 
#    read_xlsx("src/data/Final advice set (120 - 20x2x3).xlsx") 


# --- Clean Up the Subjects Data --- #
subject_clean <-
    subject_df %>%
    # completes the experiment -- 
    # needed to check the authors paper to find what variable delineates "finishing"
    # the task
    filter(completed_scales_turing == 1) %>%
    #filter(completed_all == 1)
    # treatment determined by the 'random_number' a subject is assigned
    # so lets rename it so we dont have to think about that again
    rename(treatment = random_number) %>%
    # control condition ("No advice") is treatment 1
    mutate(no_advice = if_else(treatment == 1, 
                               TRUE, 
                               FALSE
    )
    ) %>%
    # treatment assignment based on morality also happens for the control subjects 
    # (in no_advice)
    # so lets create a variable that has treatment indicators that don't overlap 
    # with the baseline/no_advice variable 
    mutate(
        treatment_morality = case_when(
            no_advice == FALSE & moral == "Honest" ~ "honest",
            no_advice == FALSE & moral == "Dishonest aligned" ~ "dishonest_aligned",
            no_advice == FALSE & moral == "Dishonest" ~ "dishonest",
            .default = "no_advice"
        )
    ) %>%
    # do the same thing for the source variable
    mutate(
        treatment_source = case_when(
            no_advice == FALSE & source == "AI" ~ "ai",
            no_advice == FALSE & source == "Human" ~ "human",
            .default = "no_advice"
        )
    ) %>%
    # And once more for the transparency variable
    mutate(
        treatment_transparency = case_when(
            no_advice == FALSE & transparency == "Not transparent" ~ "not_transparent",
            no_advice == FALSE & transparency == "Transparent" ~ "transparent",
            .default = "no_advice"
        )
    ) %>%
    # main results in the paper don't use the "Dishonest aligned" treatment
    # so let's remove it for now
    filter(
        treatment_morality != "dishonest_aligned"
    ) %>%
    # Create an extra outcome variable: 
    # if subject reports a "6" code it as such
    mutate(report_six = if_else(report == 6, 
                                TRUE, 
                                FALSE)
    ) %>%
    # throwaway control question columns -- not needed later on
    select(!starts_with("control_q")) %>%
    # Also throw away the attention check
    select(!starts_with("attention")) %>%
    mutate(report = as.numeric(report))

## --- Treatment Identifier  --- #
# Interaction of three  variables define which treatment a subject is in
# We create a variable `treatment_combined` that summarises all of this info into
# one variable
# 
# The variables that define treatment are:
# - transparency, 
# - moral, 
# - source
 
subjects_clean_treatments <-
    subject_clean %>%
    mutate(treatment_combined = 
               case_when(
                   source == "AI" & moral == "Honest" & 
                       transparency == "Not Transparent" & control_treatment == 0 
                   ~ "ai_honest_opaque",
                   source == "AI" & moral == "Dishonest" & 
                       transparency == "Not Transparent" & control_treatment == 0 
                   ~ "ai_dishonest_opaque",
                   source == "Human" & moral == "Honest" & 
                       transparency == "Not Transparent" & control_treatment == 0 
                   ~ "human_honest_opaque",
                   source == "Human" & moral == "Dishonest" & 
                       transparency == "Not Transparent" & control_treatment == 0 
                   ~ "human_dishonest_opaque",
                   source == "AI" & moral == "Honest" & 
                       transparency == "Transparent" & control_treatment == 0 
                   ~ "ai_honest_transparent",
                   source == "AI" & moral == "Dishonest" & 
                       transparency == "Transparent" & control_treatment == 0 
                   ~ "ai_dishonest_transparent",
                   source == "Human" & moral == "Honest" & 
                       transparency == "Transparent" & control_treatment == 0 
                   ~ "human_honest_transparent",
                   source == "Human" & moral == "Dishonest" & 
                       transparency == "Transparent" & control_treatment == 0 
                   ~ "human_dishonest_transparent",
                   .default = "control"
               )
    )

# --- Write dataset to file ---- #
# This is the data we use in the later analysis
readr::write_csv(subjects_clean_treatments, 
                 "out/data/analysis_data_subjects.csv"
                 )
