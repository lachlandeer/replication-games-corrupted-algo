# --- Load Libraries --- #
library(readr)
library(dplyr)
library(rlist)
library(estimatr)
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

# first paragraph of 3.1.1
model_1_df <-
    df %>%
    filter(treatment_combined 
           %in% c('control',
                  'ai_dishonest_opaque',
                  'ai_honest_opaque'
           )
    )

mod1 <- 
    lm_robust(report_six ~ I(relevel(as.factor(treatment_combined), 
                          ref = "control"))
       , data = model_1_df
    )
summary(mod1)

mod1_glm <- 
    glm(report_six ~ I(relevel(as.factor(treatment_combined), 
                              ref = "control"))
       , family = "binomial"
       , data = model_1_df
    )
summary(mod1_glm)

# second paragraph of 3.1.1
model_2_df <-
    df %>%
    filter(stringr::str_detect(treatment_combined, "opaque")) %>%
    mutate(
        # human vs Ai : Source
        src_dummy = if_else(source == "Human", 0, 1),
        # advice coded
        moral_dummy = if_else(moral =="Honest", 0, 1)
    )

# we need to check the interpretation of the middle sentence of this paragraph -- which combo coefficients are being used?
mod2 <- lm_robust(report_six ~ I(relevel(as.factor(moral), ref = "Honest")) * 
                      I(relevel(as.factor(source), ref = "AI")),
                  #family = "binomial",
                  data = model_2_df)
summary(mod2)

mod2_glm <- glm(report_six ~ I(relevel(as.factor(moral), ref = "Honest")) * 
                     I(relevel(as.factor(source), ref = "AI")),
                 family = "binomial",
                 data = model_2_df)

# coef I(relevel(as.factor(source), ref = "AI"))Human is the sentence
#" The proportion of sixes does not differ between the AI-generated (21.94%) and 
# human-written treatments when the advice is honesty promoting (19.29%, b = −0.162, p = 0.516, 95% CI = [−0.655, 0.327])."
#

# comparing I(relevel(as.factor(moral), ref = "Honest"))Dishonest to
# I(relevel(as.factor(moral), ref = "Honest"))Dishonest:I(relevel(as.factor(source), ref = "AI"))Human
# is the sentence
# Similarly, the proportion of sixes does not differ between the AI-generated (32.44%) and human-written treatments when the advice is dishonesty promoting (38.92%, b = 0.283, p = 0.173, 95% CI = [−0.124, 690]).

# the three way interaction is the last coefficient here
mod3_df <-
    df %>%
    filter(treatment_combined != "control") 

mod3 <- lm_robust(report_six ~
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

mod3_glm <- glm(report_six ~
               I(relevel(as.factor(moral), 
                         ref = "Honest")
               ) *
               I(relevel(as.factor(source), 
                         ref = "AI")
               ) *
               I(relevel(as.factor(transparency), 
                         ref = "Not Transparent")
               )
           , family = "binomial"
           , data = mod3_df
)

# --- Package the models into a list for export --- #
reg_list <- list(
    'mod1_glm' = mod1_glm,
    'mod2_glm' = mod2_glm,
    'mod3_glm' = mod3_glm,
    'mod1' = mod1,
    'mod2' = mod2,
    'mod3' = mod3
)

# --- Export --- #
list.save(reg_list, 
          opt$out)
