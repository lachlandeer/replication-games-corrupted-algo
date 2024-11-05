# --- Load Libraries --- #
library(rlist)
library(modelsummary)
library(tibble)
library(kableExtra)
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
                default = "out.tex",
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

# --- Extra Info to add to the table --- #
# setting up column names of table
col_names <- c('(1)', '(2)', '(3)', '(4)', '(5)', '(6)', '(7)')
names(models) <- col_names

# Adding a name for the dependent variable
dep_var <- c(' ' =1, 'Dependent variable: reported die-roll outcome' =6)

# Mapping coefficients to human readable 
cm <- c(
        'I(relevel(as.factor(treatment_combined), ref = "control"))ai_honest_opaque' = "No advice",
        'I(relevel(as.factor(treatment_combined), ref = "control"))ai_dishonest_opaque' = 'Dishonesty-promoting',
        'I(relevel(as.factor(moral), ref = "Honest"))Dishonest' = 'Dishonesty-promoting',
        'I(relevel(as.factor(source), ref = "AI"))Human' = 'Human-written',
        'I(relevel(as.factor(transparency), ref = "Not Transparent"))Transparent' = 'Transparent',
        'I(relevel(as.factor(moral), ref = "Honest"))Dishonest:I(relevel(as.factor(source), ref = "AI"))Human' = 'Dishonesty-promoting $\\times$ Human',
        'I(relevel(as.factor(moral), ref = "Honest"))Dishonest:I(relevel(as.factor(transparency), ref = "Not Transparent"))Transparent' = 'Dishonesty-promoting $\\times$ Transparent',
        'I(relevel(as.factor(source), ref = "AI"))Human:I(relevel(as.factor(transparency), ref = "Not Transparent"))Transparent' = 'Human $\\times$ Transparent',
        'I(relevel(as.factor(moral), ref = "Honest"))Dishonest:I(relevel(as.factor(source), ref = "AI"))Human:I(relevel(as.factor(transparency), ref = "Not Transparent"))Transparent' = 'Dishonesty-promoting $\\times$ Human $\\times$ Transparent',
        # we omit controls and present them as Yes/No
        # finally the intercept
        '(Intercept)' = 'Intercept'
        )

# Additional Rows to add to table
add_rows <-tribble(
    ~term, ~'(1)', ~'(2)', ~'(3)', ~'(4)', ~'(5)', ~'(6)', ~'(7)',
    'Interactions', '', '', '', '', '', '', '',
    'Additional Controls', '', '', '', '', '', '', '',
    'Norms', 'No', 'No', 'No', 'Yes', 'Yes', 'Yes', 'Yes',
    'Demographics', 'No', 'No', 'No', 'No', 'Yes', 'Yes', 'Yes',
    'Advice Readability', 'No', 'No', 'No', 'No', 'No', 'Yes', 'Yes',
    'Guess Correctly', 'No', 'No', 'No', 'No', 'No', 'No', 'Yes')


attr(add_rows, 'position') <- c(9, 20, 21, 22, 23, 24)

#--- Create the Regression Table --- #
tab <-
    modelsummary(models,
             fmt = 3,
             stars = TRUE,
             #stars = c('*' = .1, '**' = .05, '***' = 0.01),
             coef_map = cm,
             coef_omit = "personal|justification|shared|age|Male|grammarly|read|guess_correct",
             add_rows = add_rows,
             gof_omit = 'R2 Adj|AIC|BIC|RMSE|Log',
             gof_map = c("r.squared", "nobs"),
             output = 'latex_tabular',
             escape = FALSE # render latex as latex- needs FALSE
            )  %>%
    add_header_above(dep_var) %>%
    row_spec(24, 
             extra_latex_after = "\\midrule")


# --- Save the Output --- #
tab

tab %>%
    save_kable(file = opt$out, self_contained = FALSE)
