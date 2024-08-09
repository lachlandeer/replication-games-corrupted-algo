# 
library(readr)
library(dplyr)
library(rlist)

# --- Load Data --- #
df <- 
    read_csv("out/data/analysis_data_subjects_with_advice.csv")

# --- Regression Models --- #

#  Col 1
model_1_df <-
    df %>%
    filter(treatment_combined 
           %in% c('control',
                  'ai_dishonest_opaque',
                  'ai_honest_opaque'
                    )
    )

mod1 <- 
    lm(report ~ I(relevel(as.factor(treatment_combined), 
                          ref = "control"))
       , data = model_1_df
       )
summary(mod1)

# Col 2
model_2_df <-
    df %>%
    filter(stringr::str_detect(treatment_combined, "opaque")) %>%
    mutate(
        # human vs Ai : Source
        src_dummy = if_else(source == "Human", 0, 1),
        # advice coded
        moral_dummy = if_else(moral =="Honest", 0, 1)
    )

mod2 <- lm(report ~ I(relevel(as.factor(moral), 
                              ref = "Honest")
                      ) * 
               I(relevel(as.factor(source), 
                         ref = "AI")
                 )
           , data = model_2_df)
summary(mod2)

# Col 3
# Remark: mod3_df also the right set of observations
# for col 4
mod3_df <-
    df %>%
    filter(treatment_combined != "control") 

mod3 <- lm(report ~
               I(relevel(as.factor(moral), 
                         ref = "Honest")
                 ) *
               I(relevel(as.factor(source), 
                         ref = "AI")
                 ) *
               I(relevel(as.factor(transparency), 
                         ref = "Not Transparent")
                 )
           , data = mod3_df
)
summary(mod3)

# Col 4
mod4 <- lm(report ~
               I(relevel(as.factor(moral),
                         ref = "Honest")
                 ) *
               I(relevel(as.factor(source), 
                         ref = "AI")
                 ) *
               I(relevel(as.factor(transparency), 
                         ref = "Not Transparent")
                 ) +
               personal_injunctive_1 + 
               personal_descriptive_1 +
               justification_1 + 
               shared_responsibility_1
           , data = mod3_df
)
summary(mod4)

# Col 5
mod5_df <- 
    mod3_df %>%
    filter(gender %in% c("Male", "Female"))

mod5 <- lm(report ~
               I(relevel(as.factor(moral), 
                         ref = "Honest")
                 ) *
               I(relevel(as.factor(source), 
                         ref = "AI")
                 ) *
               I(relevel(as.factor(transparency), 
                         ref = "Not Transparent")
                 ) +
               personal_injunctive_1 + 
               personal_descriptive_1 +
               justification_1 + 
               shared_responsibility_1 + 
               age + 
               I(relevel(as.factor(gender), 
                         ref = "Female")
                       )
           , data = mod5_df
)
summary(mod5)

# Col 6
mod6 <- lm(report ~
               I(relevel(as.factor(moral), 
                         ref = "Honest")
                 ) *
               I(relevel(as.factor(source), 
                         ref = "AI")
                 ) *
               I(relevel(as.factor(transparency), 
                         ref = "Not Transparent")
                 ) +
               personal_injunctive_1 + 
               personal_descriptive_1 +
               justification_1 + 
               shared_responsibility_1 + 
               age + 
               I(relevel(as.factor(gender), 
                         ref = "Female")
                 ) +
               grammarly + read
           , data = mod5_df
)
summary(mod6)   

# --- Package the models into a list for export --- #
reg_list <- list(
    'mod1' = mod1,
    'mod2' = mod2,
    'mod3' = mod3,
    'mod4' = mod4,
    'mod5' = mod5,
    'mod6' = mod6
    )

# --- Export --- #
list.save(reg_list, 
          "out/analysis/table_1_models.Rds")