library(readr)
library(dplyr)
library(rstatix)
library(tidyr)
library(tibble)
library(optparse)
library(jsonlite)


#--- CLI parsing --- #
option_list = list(
    make_option(c("-d", "--data"),
                type = "character",
                default = NULL,
                help = "a csv file name",
                metavar = "character"),
	make_option(c("-o", "--out"),
                type = "character",
                default = "out.tex",
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
    mutate(treatment_combined = 
               factor(treatment_combined, 
                      levels=c("control", 
                               "ai_honest_opaque", 
                               "ai_dishonest_opaque", 
                               "human_honest_opaque", 
                               "human_dishonest_opaque",  
                               "ai_honest_transparent", 
                               "ai_dishonest_transparent", 
                               "human_honest_transparent", 
                               "human_dishonest_transparent" 
                      )
               )
    )

# --- Get Data for Turing Test --- #
# Select rows where subject took turing test, and then create indicators for whether correct guess 
df <-
    df %>%
    filter(!is.na(turing_test_guess_ai)) %>%
    mutate(guess_correct_ai    = if_else(turing_test_guess_ai == 1 & source == "AI", TRUE, FALSE),
           guess_correct_human = if_else(turing_test_guess_ai == 0 & source == "Human", TRUE, FALSE),
           guess_correct = guess_correct_ai | guess_correct_human == 1)

# get summary numbers
sample_size <- nrow(df)

correct_guess <- 
    df %>%
    filter(guess_correct == TRUE) %>%
    nrow()

# --- Run Binomial Test for correct guesses --- #
out <- rstatix::binom_test(
    n = as.integer(sample_size),
    x = as.integer(correct_guess),
    p = 0.5,
    alternative = "two.sided",
    conf.level = 0.95,
    detailed = TRUE
)

#--- Convert output list to JSON and save it --- #
message("converting to json")
json_output <- toJSON(out, pretty = TRUE)
write(json_output, opt$out)