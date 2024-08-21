
# --- Load Libraries --- #
library(readr)
library(dplyr)
library(rlist)
library(car)

# --- Load Data --- #
df <- 
    read_csv("out/data/analysis_data_subjects_with_advice.csv")

# --- Data Selection --- #
# select data where norms are present
# occurs when in treatments that are not control treatment
df_reg <-
    df %>%
    filter(treatment_combined != "control") %>%
    filter(stringr::str_detect(treatment_combined, "transparent"))

# --- Regression Models --- #
# injunctive norms
mod_inj <-
    lm(personal_injunctive_1 ~ as.factor(moral), data = df_reg)

summary(mod_inj)

mod_inj_int <-
    lm(personal_injunctive_1 ~ as.factor(moral)*as.factor(source), data = df_reg)

summary(mod_inj_int)

# hypothesis_matrix <- matrix(c(0, 0, 0, 1), nrow = 1)
# linearHypothesis(mod_inj_int, hypothesis_matrix)


# descriptive norms
mod_desc <-
    lm_robust(personal_descriptive_1 ~ as.factor(moral), data = df_reg)

summary(mod_desc)

mod_desc_int <-
    lm(personal_descriptive_1 ~ as.factor(moral)*as.factor(source), data = df_reg)

summary(mod_desc_int)

# justification
mod_just <-
    lm_robust(justification_1 ~ as.factor(moral), data = df_reg)

summary(mod_just)

mod_just_int <-
    lm(justification_1 ~ as.factor(moral)*as.factor(source), data = df_reg)

summary(mod_just_int)

# shared responsibility
rstatix::t_test(df_reg, shared_responsibility_1~ 1, mu = 50)

mod_share <-
    lm_robust(shared_responsibility_1 ~ as.factor(source), data = df_reg)

summary(mod_share)

mod_share_int <-
    lm(shared_responsibility_1 ~ as.factor(moral)*as.factor(source), data = df_reg)

summary(mod_share_int)

# --- Package the models into a list for export --- #
reg_list <- list(
    'mod_inj'       = mod_inj,
    'mod_inj_int'   = mod_inj_int,
    'mod_desc'      = mod_desc,
    'mod_desc_int'  = mod_desc_int,
    'mod_just'      = mod_just,
    'mod_just_int'  = mod_just_int,
    'mod_share'     = mod_share,
    'mod_share_int' = mod_share_int
)

# --- Export --- #
list.save(reg_list, 
          "out/analysis/mechanism_models.Rds")
