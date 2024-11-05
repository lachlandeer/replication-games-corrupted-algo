# create_regression_data.R
#
# What this file does:
#   - Merges cleaned subject and advice data into one file
#     to be used in regression analysis
#

# --- Load libraries --- #
library(optparse)
library(rjson)
library(readr)
library(dplyr)

 #--- CLI parsing --- #
option_list = list(
    make_option(c("-s", "--subjects"),
                type = "character",
                default = NULL,
                help = "a dataset of subject choices",
                metavar = "character"),
   make_option(c("-a", "--advice"),
               type = "character",
               default = NULL,
               help = "A dataset of advice"
   ),
	make_option(c("-o", "--out"),
                type = "character",
                default = "out.csv",
                help = "output file name [default = %default]",
                metavar = "character")
    );

opt_parser = OptionParser(option_list = option_list);
opt = parse_args(opt_parser);

if (is.null(opt$subjects)){
  print_help(opt_parser)
  stop("Subjects data must be provided", call. = FALSE)
}
if (is.null(opt$advice)){
 print_help(opt_parser)
 stop("Advice data must be provided", call. = FALSE)
}


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
