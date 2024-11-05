# --- Load Libraries --- #
library(car)
library(rlist)
library(estimatr)
library(jsonlite)
library(optparse)

 #--- CLI parsing --- #
option_list = list(
    make_option(c("-m", "--models"),
                type = "character",
                default = NULL,
                help = "a Rds file name",
                metavar = "character"),
	make_option(c("-o", "--out"),
                type = "character",
                default = "out.json",
                help = "output file name [default = %default]",
                metavar = "character")
    );

opt_parser = OptionParser(option_list = option_list);
opt = parse_args(opt_parser);

if (is.null(opt$models)){
  print_help(opt_parser)
  stop("Input models must be provided", call. = FALSE)
}


# --- Load Regression Models --- #
models <- list.load(opt$models)

# Create a list to hold all output
output <- list()

# --- Coefficient Tests --- #
# mod 1
message("running tests on model 1")
mod_1 <- models$mod1

summary(mod_1)

output$mod1 <- list(
  #summary = summary(mod_1),
  hypothesis_tests = list(
    test_1 = list(
      description = "Test for effect of Variable1",
      result = linearHypothesis(mod_1, matrix(c(0, 1, 0), nrow = 1))
    ),
    test_2 = list(
      description = "Test for effect of Variable2",
      result = linearHypothesis(mod_1, matrix(c(0, 0, 1), nrow = 1))
    ),
    test_3 = list(
      description = "Test for difference between Variable1 and Variable2",
      result = linearHypothesis(mod_1, matrix(c(0, 1, -1), nrow = 1))
    )
  )
)

# mod 2
message("running tests on model 2")
mod_2 <- models$mod2
output$mod2 <- list(
  #summary = summary(mod_2),
  hypothesis_tests = list(
    interaction = list(
      description = "Test for interaction effect",
      result = linearHypothesis(mod_2, matrix(c(0, 0, 0, 1), nrow = 1))
    ),
    honesty_promoting = list(
      description = "Test for honesty-promoting condition (human vs. AI)",
      result = linearHypothesis(mod_2, matrix(c(0, 0, 1, 0), nrow = 1))
    ),
    dishonesty_promoting = list(
      description = "Test for dishonesty-promoting condition (human vs. AI)",
      result = linearHypothesis(mod_2, matrix(c(0, 0, 1, 1), nrow = 1))
    )
  )
)

# mod 3
message("running tests on model 3")
mod_3 <- models$mod3

output$mod3 <- list(
  #summary = summary(mod_3),
  hypothesis_tests = list(
    three_way_interaction = list(
      description = "Test for three-way interaction effect",
      result = linearHypothesis(mod_3, matrix(c(0, 0, 0, 0, 0, 0, 0, 1), nrow = 1))
    ),
    two_way_transparency = list(
      description = "Test for two-way transparency interaction",
      result = linearHypothesis(mod_3, matrix(c(0, 0, 1, 0, 0, 0, 1, 0), nrow = 1))
    ),
    two_way_opacity = list(
      description = "Test for two-way opacity interaction",
      result = linearHypothesis(mod_3, matrix(c(0, 0, 1, 0, 1, 0, 0, 0), nrow = 1))
    )
  )
)

#--- Convert output list to JSON and save it --- #
message("converting to json")
json_output <- toJSON(output, pretty = TRUE)
write(json_output, opt$out)
