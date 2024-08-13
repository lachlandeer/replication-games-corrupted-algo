
# --- Load Libraries --- #
library(car)
library(rlist)

# --- Load Regression Models --- #
models <- 
    list.load("out/analysis/report_six_models.Rds")

# --- Coefficient Tests --- #
# mod 1
mod_1 <- models$mod1
summary(mod_1)

hypothesis_matrix <- matrix(c(0, 1, 0), nrow = 1)
linearHypothesis(mod_1, hypothesis_matrix)

hypothesis_matrix <- matrix(c(0, 0, 1), nrow = 1)
linearHypothesis(mod_1, hypothesis_matrix)

hypothesis_matrix <- matrix(c(0, 1, -1), nrow = 1)
linearHypothesis(mod_1, hypothesis_matrix)

# mod 2
mod_2 <- models$mod2
summary(mod_2)

# the interaction
hypothesis_matrix <- matrix(c(0, 0, 0, 1), nrow = 1)
linearHypothesis(mod_2, hypothesis_matrix)

# honesty promoting -- human vs AI
hypothesis_matrix <- matrix(c(0, 0, 1, 0), nrow = 1)
linearHypothesis(mod_2, hypothesis_matrix)

# dishonesty promoting human vs AI
hypothesis_matrix <- matrix(c(0, 0, 1, 1), nrow = 1)
linearHypothesis(mod_2, hypothesis_matrix)

# mod 3
mod_3 <- models$mod3
summary(mod_3)

# three way interaction
hypothesis_matrix <- matrix(c(0, 0, 0, 0, 0 , 0, 0, 1), nrow = 1)
linearHypothesis(mod_3, hypothesis_matrix)

# two way transparency
hypothesis_matrix <- matrix(c(0, 0, 1, 0, 0 , 0, 1, 0), nrow = 1)
linearHypothesis(mod_3, hypothesis_matrix)

# two way opacity
hypothesis_matrix <- matrix(c(0, 0, 1, 0, 1 , 0, 0, 0), nrow = 1)
linearHypothesis(mod_3, hypothesis_matrix)
