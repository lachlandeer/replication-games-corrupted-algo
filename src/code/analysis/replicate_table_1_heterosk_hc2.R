# replicate_table_heterosk_hc2.R
#
# What this file does:
#  - Replicates Table 1 of LKRHI wiht HC2 standard errors
#

# --- Load Libraries --- #
library(readr)
library(dplyr)
library(estimatr)
library(rlist)
library(optparse)

 #--- CLI parsing --- #
option_list = list(
    make_option(c("-d", "--data"),
                type = "character",
                default = NULL,
                help = "a csv file name",
                metavar = "character"),
	make_option(c("-o", "--out"),
                type = "character",
                default = "out.csv",
                help = "output file name [default = %default]",
                metavar = "character")
    );

opt_parser = OptionParser(option_list = option_list);
opt = parse_args(opt_parser);

if (is.null(opt$data)){
  print_help(opt_parser)
  stop("Input data must be provided", call. = FALSE)
}


# --- Load Data --- #
df <- 
    read_csv(opt$data)

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
    lm_robust(report ~ I(relevel(as.factor(treatment_combined), 
                          ref = "control"))
       , se_type = "HC2"
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

mod2 <- lm_robust(report ~ I(relevel(as.factor(moral), 
                              ref = "Honest")
                      ) * 
               I(relevel(as.factor(source), 
                         ref = "AI")
                 )
           , se_type = "HC2"
           , data = model_2_df)
summary(mod2)

# Col 3
# Remark: mod3_df also the right set of observations
# for col 4
mod3_df <-
    df %>%
    filter(treatment_combined != "control") 

mod3 <- lm_robust(report ~
               I(relevel(as.factor(moral), 
                         ref = "Honest")
                 ) *
               I(relevel(as.factor(source), 
                         ref = "AI")
                 ) *
               I(relevel(as.factor(transparency), 
                         ref = "Not Transparent")
                 )
           , se_type = "HC2"
           , data = mod3_df
)
summary(mod3)

# Col 4
mod4 <- lm_robust(report ~
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
           , se_type = "HC2"
           , data = mod3_df
)
summary(mod4)

# Col 5
mod5_df <- 
    mod3_df %>%
    filter(gender %in% c("Male", "Female"))

mod5 <- lm_robust(report ~
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
           , se_type = "HC2"
           , data = mod5_df
)
summary(mod5)

# Col 6
mod6 <- lm_robust(report ~
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
           , se_type = "HC2"
           , data = mod5_df
)
summary(mod6)   

# mod 7
mod7_df <-
    mod5_df %>%
    filter(stringr::str_detect(treatment_combined, 
                               "opaque")
           ) %>%
    mutate(
        guess_correct = case_when(
            (turing_test_guess_ai == 1 & source == "AI") | 
                (turing_test_guess_ai == 0 & source == "Human") ~ TRUE,
            .default = FALSE
        )
    )

mod7 <- lm_robust(report ~
               I(relevel(as.factor(moral), 
                         ref = "Honest")
                 ) *
               I(relevel(as.factor(source), 
                         ref = "AI")
                 ) +
               personal_injunctive_1 + 
               personal_descriptive_1 +
               justification_1 + 
               shared_responsibility_1 + 
               age + 
               I(relevel(as.factor(gender), 
                         ref = "Female")
                 ) +
               grammarly + read + as.factor(guess_correct)
           , se_type = "HC2"
           , data = mod7_df
)
summary(mod7) 

# --- Package the models into a list for export --- #
reg_list <- list(
    'mod1' = mod1,
    'mod2' = mod2,
    'mod3' = mod3,
    'mod4' = mod4,
    'mod5' = mod5,
    'mod6' = mod6,
    'mod7' = mod7
    )

# --- Export --- #
list.save(reg_list, 
          opt$out)
