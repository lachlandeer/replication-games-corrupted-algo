library(readr)
library(dplyr)
library(rstatix)
library(tidyr)
library(kableExtra)

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

# --- Load and Manipulate Data Structure --- #

df <- 
    read_csv(opt$data)

df %>% t_test(report ~ 1, mu = 3.5)


df_nest <-
    df %>% 
    nest(-treatment_combined) 

# --- T-testing --- #

mod_fit <- function(data) {
    data %>%
    t_test(report ~ 1, mu = 3.5)
}


df_model <- df_nest %>% 
    mutate(model = purrr::map(data, mod_fit))    

res <- 
    df_model %>%
    unnest(model) %>%
    mutate(
        p.adj.signif = case_when(
            p < 0.01 ~ "***",
            p < 0.05  ~ "**",
            p < 0.1  ~ "*",
            TRUE          ~ ""
        )
    ) %>%
    #mutate(t_stat_signif = sprintf("%.2f %s", statistic, p.adj.signif))  # Combine t-stat and stars
    mutate(t_stat_signif = sprintf("%.2f %s", statistic, p.adj.signif)) %>%
    mutate(
        treatment_combined = case_when(
            treatment_combined == "control" ~ "No Advice",
            treatment_combined == "ai_honest_opaque" ~ "AI $\\times$ Honest $\\times$ Opaque",
            treatment_combined == "ai_dishonest_opaque" ~ "AI $\\times$ Dishonest $\\times$ Opaque",
            treatment_combined == "human_honest_opaque" ~ "Human $\\times$ Honest $\\times$ Opaque",
            treatment_combined == "human_dishonest_opaque" ~ "Human $\\times$ Dishonest $\\times$ Opaque",
            treatment_combined == "ai_honest_transparent" ~ "AI $\\times$ Honest $\\times$ Transparent",
            treatment_combined == "ai_dishonest_transparent" ~ "AI $\\times$ Dishonest $\\times$ Transparent",
            treatment_combined == "human_honest_transparent" ~ "Human $\\times$ Honest $\\times$ Transparent",
            treatment_combined == "human_dishonest_transparent" ~ "Human $\\times$ Dishonest $\\times$ Transparent"
        )
    )

# --- Convert to Table --- #
tab <- 
    res %>%
    select(treatment_combined, t_stat_signif) %>%
    kbl(booktabs = TRUE, escape = FALSE, col.names = NULL, format = "latex") %>%
    kable_styling(full_width = FALSE, position = "center") %>%
    add_header_above(c("Treatemnt" = 1, "Test Statistic" = 1))

# --- Save the Output --- #
tab

tab %>%
    save_kable(file = opt$out, self_contained = FALSE)

