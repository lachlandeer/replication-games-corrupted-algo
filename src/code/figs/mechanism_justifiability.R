# --- Load Libraries --- #
library(readr)
library(dplyr)
library(ggpubr)
library(ggpubfigs)
library(ggh4x)

# --- Load Data --- #
df <- 
    read_csv("out/data/analysis_data_subjects_with_advice.csv")

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
    ggerrorplot(y = "justification_1", x = "treatment_combined",
                desc_stat = "mean_se",
                error.plot = "errorbar",
                color = "black"
                #palette = "npg"
    ) +
    stat_summary(aes(treatment_combined, justification_1, fill = as.factor(color_var)), alpha = 0.5, fun = mean, geom = "bar") +
    stat_compare_means(
        comparisons = list(c("ai_honest_transparent", "human_honest_transparent"), 
                           c("ai_dishonest_transparent", "human_dishonest_transparent")
                          #c("ai_honest_transparent", "ai_dishonest_transparent")
        ),
        label = "p.signif",
        method = "t.test",
        label.y = c(45, 45),
        symnum.args = list(cutpoints = c(0, 0.001, 0.01, 0.05, Inf), symbols = c("***", "**", "*", "ns"))
    ) +
    geom_bracket(
        xmin = "ai_honest_transparent", xmax = "ai_dishonest_transparent", y.position = 60,
        label = "***", 
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
    ylab("Perceived Justifiability")

ggsave("out/figs/justifiability_treatment.pdf")
