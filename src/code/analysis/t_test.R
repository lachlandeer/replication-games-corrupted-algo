# --- Load Libraries --- #
library(readr)
library(dplyr)
library(rstatix)
library(tidyr)
library(tibble)
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

# Perform pairwise t-tests with Bonferroni adjustment
res <- df %>%
    t_test(report ~ treatment_combined, paired = FALSE) %>%
    adjust_pvalue(method = "bonferroni") %>%
    add_significance("p.adj") %>%
    mutate(
        p.adj.signif = case_when(
            p.adj < 0.01 ~ "***",
            p.adj < 0.05  ~ "**",
            p.adj < 0.1  ~ "*",
            TRUE          ~ ""
        )
    ) %>%
    #mutate(t_stat_signif = sprintf("%.2f %s", statistic, p.adj.signif))  # Combine t-stat and stars
    mutate(t_stat_signif = sprintf("%.2f %s", statistic, p.adj.signif)) 

# Create the matrix with t-statistics and significance stars
t_matrix_signif <- res %>%
    select(group1, group2, t_stat_signif) %>%
    pivot_wider(names_from = group2, values_from = t_stat_signif, values_fill = "-") %>%
    mutate(
        group1 = case_when(
            group1 == "control" ~ "No Advice",
            group1 == "ai_honest_opaque" ~ "AI $\\times$ Honest $\\times$ Opaque",
            group1 == "ai_dishonest_opaque" ~ "AI $\\times$ Dishonest $\\times$ Opaque",
            group1 == "human_honest_opaque" ~ "Human $\\times$ Honest $\\times$ Opaque",
            group1 == "human_dishonest_opaque" ~ "Human $\\times$ Dishonest $\\times$ Opaque",
            group1 == "ai_honest_transparent" ~ "AI $\\times$ Honest $\\times$ Transparent",
            group1 == "ai_dishonest_transparent" ~ "AI $\\times$ Dishonest $\\times$ Transparent",
            group1 == "human_honest_transparent" ~ "Human $\\times$ Honest $\\times$ Transparent"
        )
    ) %>%
    column_to_rownames("group1")

tab <-
    t_matrix_signif %>%
    kbl(booktabs = TRUE, escape = FALSE, col.names = NULL, format = "latex") %>%
    kable_styling(full_width = FALSE, position = "center") %>%
    #column_spec(2:ncol(df), latex = "S[table-format=1.3, round-mode=places, round-precision=3]") %>%
    # kbl(col.names = NULL,
    #     booktabs = TRUE,
    #     escape = FALSE,  # To allow LaTeX commands
    #     col.names = c("Treatment", "Proportion \\(\\pm\\) SE")  # Customize column names
    # ) %>%
    # kable_styling(
    #     latex_options = c("hold_position"),
    #     full_width = FALSE
    # ) %>%
    #kable_styling(full_width = TRUE, position = "center") %>%
    #add_header_above(c(" " = 1, "Group Comparisons" = ncol(t_matrix_signif))) %>%
    add_header_above(c(" " = 1, "Honest" = 1, "Dishonest" = 1,  "Honest" = 1, "Dishonest" = 1,  "Honest" = 1, "Dishonest" = 1,  "Honest" = 1, "Dishonest" = 1 )) %>%
    add_header_above(c(" " = 1, "AI Generated" = 2, "Human Written" = 2, "AI Generated" = 2, "Human Written" = 2 )) %>%
    add_header_above(c(" " = 1, "Opacity" = 4, "Transparency" = 4))
    
# --- Save the Output --- #
tab

tab %>%
    save_kable(
        file = opt$out, 
        self_contained = FALSE
        )
