# --- Load Libraries --- #
library(readr)
library(dplyr)
library(ggpubr)
library(ggpubfigs)
library(ggh4x)
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
                default = "out.pdf",
                help = "output file name [default = %default]",
                metavar = "character")
    );

opt_parser = OptionParser(option_list = option_list);
opt = parse_args(opt_parser);

if (is.null(opt$data)){
  print_help(opt_parser)
  stop("Input models must be provided", call. = FALSE)
}


# --- Load Data --- #
df <- 
    read_csv(opt$data)

# --- Data Selection --- #
# select data where norms are present
# occurs when in treatments that are not control treatment
df <-
    df %>%
    filter(treatment_combined != "control") %>%
    filter(stringr::str_detect(treatment_combined, "transparent")) %>%
    # a variable to color plot by
    mutate(
        color_var = case_when(
            stringr::str_detect(treatment_combined, "ai") == TRUE ~ "AI",
            .default = "Human"
        )
    ) %>%
    # recode order so the plot mimics the paper
    mutate(treatment_combined = 
               factor(treatment_combined, 
                      levels=c(
                               "ai_honest_transparent", 
                               "human_honest_transparent",
                               "ai_dishonest_transparent", 
                               "human_dishonest_transparent" 
                      )
               )
    )

df %>%
    ggerrorplot(y = "shared_responsibility_1", x = "treatment_combined",
                desc_stat = "mean_se",
                error.plot = "errorbar",
                color = "black"
                #palette = "npg"
    ) +
    stat_summary(aes(treatment_combined, shared_responsibility_1, fill = as.factor(color_var)), alpha = 0.5, fun = mean, geom = "bar") +
    stat_compare_means(
        comparisons = list(c("ai_honest_transparent", "human_honest_transparent"), 
                           c("ai_dishonest_transparent", "human_dishonest_transparent")
                          #c("ai_honest_transparent", "ai_dishonest_transparent")
        ),
        label = "p.signif",
        method = "t.test",
        label.y = c(35, 35),
        symnum.args = list(cutpoints = c(0, 0.001, 0.01, 0.05, Inf), symbols = c("***", "**", "*", "ns"))
    ) +
    geom_bracket(
        xmin = "ai_honest_transparent", xmax = "ai_dishonest_transparent", y.position = 50,
        label = "ns", 
        tip.length = c(0.03, 0.03), vjust = 0,
        position = position_nudge(x=0.5, y=0)
        #position = "jitter"
    ) +
    #stat_compare_means(data = df, mapping =  aes(x = moral, y = personal_injunctive_1))
    theme(legend.position="bottom", legend.box = "horizontal") +
    xlab("") +
    scale_fill_manual(values = friendly_pal("nickel_five"),
                      #breaks = c("ai", "human"),
                      #labels = c('AI', 'Human'),
                      name = "" 
                      ) +
    #scale_x_discrete(label = labels) +
    theme(axis.text.x = element_blank(),  # Remove default axis labels
          axis.ticks.x = element_blank(),
          axis.line.x = element_blank()
    ) +
    annotate("text", x = 1.5, y = -7.5, label = "Honesty\n Promoting", hjust = 0.5) +  # center align
    annotate("text", x = 3.5, y = -7.5, label = "Dishonesty\n Promoting", hjust = 0.5) +  # Center align
    guides(y = guide_axis_truncated(trunc_lower = 0,
                                    trunc_upper = 100)) +
    scale_y_continuous(breaks=c(0,50,100)) +
    lims(y = c(-10,100)) +
    ylab("Perceived Shared Responsibility")

ggsave(opt$out)
