# --- Load Libraries --- #
library(readr)
library(dplyr)
library(ggpubr)
library(ggpubfigs)
library(ggh4x)

# --- Load Data --- #
df <- 
    read_csv("out/data/analysis_data_subjects_with_advice.csv")


df <-
    df %>%
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
               ),
           color_var = case_when(
               treatment_combined == "control" ~  "control",
               stringr::str_detect(treatment_combined, "dishonest") == TRUE ~ "dishonest",
               .default = "honest"
           )
    )


# Custom X-axis labels 
labels <- c("No\nAdvice", "AI\nOpaque", "", "Human Opaque", "",
            "AI Transparent", "", "Human Transparent", "")


df %>%
    ggerrorplot(y = "report", x = "treatment_combined",
                desc_stat = "mean_se",
                error.plot = "errorbar",
                color = "black"
                #palette = "npg"
    ) +
    stat_summary(aes(treatment_combined, report, fill = as.factor(color_var)), alpha = 0.5, fun = mean, geom = "bar") +
    stat_compare_means(
        comparisons = list(c("ai_honest_opaque", "control"), 
                           c("control", "ai_dishonest_opaque"),
                           # these four at the same height
                           c("ai_honest_opaque", "ai_dishonest_opaque"),
                           c("human_honest_opaque", "human_dishonest_opaque"),
                           c("ai_honest_transparent", "ai_dishonest_transparent"),
                           c("human_honest_transparent", "human_dishonest_transparent"),
                           # now these
                           c("ai_honest_opaque", "human_honest_opaque"),
                           c("ai_honest_transparent", "human_honest_transparent"),
                           # finally this one
                           c("ai_dishonest_opaque", "ai_dishonest_transparent")
                           
        ),
        label = "p.signif",
        method = "t.test",
        label.y = c(4.5, 6, 5.25, 5.25, 5.25, 5.25,  6.75, 6.75, 7.5),
        symnum.args = list(cutpoints = c(0, 0.001, 0.01, 0.05, Inf), symbols = c("***", "**", "*", "ns"))
    ) +
    stat_summary(fun.data = function(x) data.frame(y=1, label = sprintf('%.2f', mean(x))), geom="text") +
    stat_summary(fun.data = function(x) data.frame(y=0.5, label = paste0("(",sprintf('%.2f', sd(x)), ")")), geom="text") +
    scale_y_continuous(breaks=c(1,2,3,4,5,6)) +
    geom_hline(yintercept = 3.5, linetype = "dashed") +
    #theme(axis.text.x=element_text(hjust = 0)) +
    # theme(legend.position = "none") +
    theme(legend.position="top", legend.box = "horizontal") +
    xlab("") +
    scale_fill_manual(values = friendly_pal("contrast_three"),
                      breaks = c("dishonest", "honest"),
                      labels = c('Dishonesty promoting advice', 'Honesty promoting advice'),
                      name = "" ) +
    #scale_x_discrete(label = labels) +
    theme(axis.text.x = element_blank(),  # Remove default axis labels
          axis.ticks.x = element_blank(),
          axis.line.x = element_blank()
    ) +
    annotate("text", x = 1, y = -0.5, label = "No\nAdvice", hjust = 0.5) +  # center align
    annotate("text", x = 2.5, y = -0.5, label = "AI\n Generated", hjust = 0.5) +  # Center align
    annotate("text", x = 4.5, y = -0.5, label = "Human\n written", hjust = 0.5) +  # Center align
    annotate("text", x = 6.5, y = -0.5, label = "AI\n Generated", hjust = 0.5) +  # Center align
    annotate("text", x = 8.5, y = -0.5, label = "Human\n written", hjust = 0.5) +  # Center align
    annotate("text", x = 3.5, y = -1.5, label = "Opacity", hjust = 0.5) +  # Center align
    annotate("text", x = 7.5, y = -1.5, label = "Transparency", hjust = 0.5) +  # Center align
    guides(y = guide_axis_truncated(trunc_lower = 0,
                                    trunc_upper = 6)) +
    ylab("Reported die-roll outcome")

ggsave("out/figs/die_roll_treatment.pdf")
