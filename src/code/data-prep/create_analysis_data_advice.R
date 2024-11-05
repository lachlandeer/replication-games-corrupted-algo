# create_analysis_data_advice.R
#
# What this file does:
#  - Cleans up raw advice data from LKRHI

# --- Load Libraries --- #
library(optparse)
library(readxl)
library(dplyr)

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
advice_df  <-
   read_xlsx(opt$data)

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
                 opt$out
)
