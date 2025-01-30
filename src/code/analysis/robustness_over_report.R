# --- Load Libraries --- #
library(readr)
library(dplyr)
library(rstatix)
library(tidyr)
library(jsonlite)
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
                default = "out.json",
                help = "output file name [default = %default]",
                metavar = "character")
    );

opt_parser = OptionParser(option_list = option_list);
opt = parse_args(opt_parser);

if (is.null(opt$data)){
  print_help(opt_parser)
  stop("Dataset must be provided", call. = FALSE)
}

# --- Load Data --- #
df <- read_csv(opt$data)

# --- Compute proportions by honest / dishonest --- #
proportion <- 
    df %>%
    group_by(treatment_combined) %>%
    summarise(
              count_1_to_3 = sum(report ==1 | report ==2, report ==3),
              count_4_to_6 = sum(report ==4 | report ==5, report ==6),
              n = n()
              )

proportion_opaque <-
    proportion %>%
    # filter opaque treatments only
    filter(!stringr::str_detect(treatment_combined, "transparent"))

proportion_by_honest <-
    proportion %>%
    # create a treatment dummy by whether honest/ dishonest or control
    mutate(honest = stringr::str_detect(treatment_combined, "_honest"),
           treatment = case_when(
               honest == TRUE ~ "Honest",
               honest == FALSE & treatment_combined != "control" ~ "Dishonest",
               .default = "No Advice"
                )
           ) %>%
    # collapse
    group_by(treatment) %>%
    summarise(
        count_1_to_3 = sum(count_1_to_3),
        count_4_to_6 = sum(count_4_to_6),
        n_obs = sum(n),
        ) %>%
    # compute proportions rather than counts to report in table
    mutate(prop_1_to_3 = count_1_to_3 / n_obs,
           prop_4_to_6 = count_4_to_6 / n_obs
           )

# --- Chi-Sq Tests --- #
out <-
    proportion_by_honest %>%
    select(treatment, contains( "count")) %>%
    tibble::column_to_rownames("treatment") %>%
    rstatix::pairwise_prop_test()

# above doesnt give chi sq stats, we will also go manually
print("No Advice vs Dishonest")

noadvice_dishonest <- 
    proportion_by_honest %>%
    filter(treatment != "Honest") %>%
    select(treatment, contains( "count")) %>%
    tibble::column_to_rownames("treatment") %>%
    chisq.test()

print(noadvice_dishonest)

print("No Advice vs honest")

noadvice_honest <- 
    proportion_by_honest %>%
    filter(treatment != "Dishonest") %>%
    select(treatment, contains( "count")) %>%
    tibble::column_to_rownames("treatment") %>%
    chisq.test()

print(noadvice_honest)

print("dishonest vs honest")

dishonest_honest <- 
    proportion_by_honest %>%
    filter(treatment != "No Advice") %>%
    select(treatment, contains( "count")) %>%
    tibble::column_to_rownames("treatment") %>%
    chisq.test()

print(dishonest_honest)

# --- Pack Results into JSON & Save --- #
output <-
    list(
        "all_pairwise" = out,
        "dishonest_honest" = unclass(dishonest_honest),
        "noadvice_honest"  = unclass(noadvice_honest),
        "noadvice_dishonest" = unclass(noadvice_dishonest)
    )

json_output <- toJSON(output, pretty = TRUE)
write(json_output, opt$out)
