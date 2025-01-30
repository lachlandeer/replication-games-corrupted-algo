# lpm of each reported outcome on dishonest

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
    read_csv(opt$data) %>%
    mutate(
        report_five  = report == 5,
        report_four  = report == 4,
        report_three = report == 3,
        report_two   = report == 2,
        report_one   = report == 1
    )


# --- Regression Models --- #
model_1_df <-
    df %>%
    filter(treatment_combined 
           %in% c('control',
                  'ai_dishonest_opaque',
                  'ai_honest_opaque'
           )
    )

mod1_one <- 
    lm_robust(report_one ~ I(relevel(as.factor(treatment_combined), 
                                     ref = "control"))
              , data = model_1_df
    )
mod1_two <- 
    lm_robust(report_two ~ I(relevel(as.factor(treatment_combined), 
                                     ref = "control"))
              , data = model_1_df
    )
mod1_three <- 
    lm_robust(report_three ~ I(relevel(as.factor(treatment_combined), 
                                     ref = "control"))
              , data = model_1_df
    )
mod1_four <- 
    lm_robust(report_four ~ I(relevel(as.factor(treatment_combined), 
                                     ref = "control"))
              , data = model_1_df
    )
mod1_five <- 
    lm_robust(report_five ~ I(relevel(as.factor(treatment_combined), 
                                     ref = "control"))
              , data = model_1_df
    )
mod1_six <- 
    lm_robust(report_six ~ I(relevel(as.factor(treatment_combined), 
                                     ref = "control"))
              , data = model_1_df
    )

# --- Package the models into a list for export --- #
reg_list <- list(
    'mod1_one' = mod1_one,
    'mod1_two' = mod1_two,
    'mod1_three' = mod1_three,
    'mod1_four' = mod1_four,
    'mod1_five' = mod1_five,
    'mod1_six' = mod1_six
)

# --- Export --- #
list.save(reg_list, 
          opt$out)