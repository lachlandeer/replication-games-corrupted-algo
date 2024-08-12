# --- Load Libraries --- #
library(readr)
library(dplyr)
library(ggpubr)
library(ggpubfigs)
library(ggh4x)

# --- Load Data --- #
df <- 
    read_csv("out/data/analysis_data_subjects_with_advice.csv")

# --- Data Manipulation --- #
# Code up order of treatments
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
               )
    )


# Compute proportions by treatment
proportions_by_treatment <- df %>%
    group_by(treatment_combined) %>%  # First, group by treatment
    mutate(total = n()) %>%  # Get the total number of observations for each treatment group
    group_by(treatment_combined, report_six) %>%  # Then group by treatment and response
    summarise(count = n(), total = first(total), .groups = 'drop') %>%  # Count the occurrences and retain the total
    mutate(proportion = count / total,  # Calculate proportion
           se = sqrt(proportion * (1 - proportion) / total)) %>%  # Calculate standard error
    mutate(color_var = case_when(
        treatment_combined == "control" ~  "control",
        stringr::str_detect(treatment_combined, "dishonest") == TRUE ~ "dishonest",
        .default = "honest"
    ))

# --- Plot --- #
ggbarplot(data = subset(proportions_by_treatment, report_six == TRUE),
               x = "treatment_combined", y = "proportion", fill = "color_var",
               alpha = 0.5,
               lab.pos = "in", 
               width = 0.93) +  # Add labels inside the bars
    ylab("Proportion of sixes") +
    geom_errorbar(data = subset(proportions_by_treatment, report_six == TRUE), 
                  aes(x = treatment_combined, ymin = proportion - se, ymax = proportion + se),
                  width = 0.2, color = "black") +
    scale_y_continuous( labels = scales::percent, breaks=c(0.1, 0.2, 0.3, 0.4)) +
    geom_hline(yintercept = 1/6, linetype = "dashed") +
    theme(legend.position="top", legend.box = "horizontal") +
    xlab("") +
    scale_fill_manual(values = friendly_pal("contrast_three"),
                      breaks = c("dishonest", "honest"),
                      labels = c('Dishonesty promoting advice', 'Honesty promoting advice'),
                      name = "" ) +
    theme(axis.text.x = element_blank(),  # Remove default axis labels
          axis.ticks.x = element_blank(),
          axis.line.x = element_blank()
    ) +
    annotate("text", x = 1, y = -0.05, label = "No\nAdvice", hjust = 0.5) +  # center align
    annotate("text", x = 2.5, y = -0.05, label = "AI\n Generated", hjust = 0.5) +  # Center align
    annotate("text", x = 4.5, y = -0.05, label = "Human\n written", hjust = 0.5) +  # Center align
    annotate("text", x = 6.5, y = -0.05, label = "AI\n Generated", hjust = 0.5) +  # Center align
    annotate("text", x = 8.5, y = -0.05, label = "Human\n written", hjust = 0.5) +  # Center align
    annotate("text", x = 3.5, y = -.15, label = "Opacity", hjust = 0.5) +  # Center align
    annotate("text", x = 7.5, y = -.15, label = "Transparency", hjust = 0.5) +  # Center align
    geom_text(data = subset(proportions_by_treatment, report_six == TRUE), 
              aes(label = scales::percent(proportion, accuracy = 0.1), 
                  y = 0.03), 
              #position = position(vjust = 0.05),
              color = "white") +  # Removed position_fill() for better alignment
    guides(y = guide_axis_truncated(trunc_lower = 0,
                                    trunc_upper = .5))


# --- Save --- #
ggsave("out/figs/prop_sixes.pdf",  height = 3.72, width = 5.5, unit = "in")
