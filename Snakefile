# Main Workflow - Corrupted Algorithms
# Contributors: @lachlandeer
import glob

# --- Importing Configuration Files --- #
configfile: "paths.yaml"

# --- PROJECT NAME --- #
PROJ_NAME = "corrupt_algs_replication"

# --- Dictionaries --- #
# # Identify subset conditions for data
# DATA_SUBSET = glob_wildcards(config["src_data_specs"] + "{fname}.json").fname
# # Models we want to estimate
# MODELS = glob_wildcards(config["src_model_specs"] + "{fname}.json").fname
# # plots we want to build
# PLOTS = glob_wildcards(config["src_figures"] + "{fname}.R").fname
# # tables to generate
# TABLES = glob_wildcards(config["src_table_specs"] + "{fname}.json").fname

# --- Variable Declarations ---- #
runR = "Rscript --no-save --no-restore --verbose"
logAll = "2>&1"

# --- Main Build Rule --- #
# all            : build paper and slides that are the core of the project
rule all:
    input:
        #mods = config["out_analysis"] + "table_1_models.Rds",
        # mod2 = config["out_analysis"] + "table_1_models_hc2.Rds",
        # mod3 = config["out_analysis"] + "table_1_models_hc3.Rds",
        report_sixes_tests = config["out_analysis"] + "report_six_model_hyps.json",
        mechanisms = config["out_analysis"] + "mechanism_models.Rds",
        t_test_treatments = config["out_tables"] + "table_ttest_pairwise_dieroll.tex",
        t_test_overreport = config["out_tables"] + "table_ttest_overreport.tex",
        t_test_aligned = config["out_tables"] + "table_ttest_pairwise_dieroll_aligned.tex",
        table_1 = config["out_tables"] + "table_1.tex",
        table_1_hc3 = config["out_tables"] + "table_1_hc3.tex",
        table_1_hc2 = config["out_tables"] + "table_1_hc2.tex",
        # data = config["out_data"] + "analysis_data_advice.csv",
        # data2 = config["out_data"] + "analysis_data_subjects.csv",
        # data3 = config["out_data"] + "analysis_data_subjects_aligned.csv",
        # data4 = config["out_data"] + "analysis_data_subjects_with_advice.csv"

# --- Cleaning Rules --- #
## clean_all      : delete all output and log files for this project
rule clean_all:
    shell:
        "rm -rf out/ log/ *.pdf *.html"

# --- Help Rules --- #
## help_main      : prints help comments for Snakefile in ROOT directory. 
##                  Help for rules in other parts of the workflows (i.e. in rules/)
##                  can be called by `snakemake help_<workflowname>`
rule help_main:
    input: "Snakefile"
    shell:
        "sed -n 's/^##//p' {input}"

# --- Sub Rules --- #
# Include all other Snakefiles that contain rules that are part of the project
# 1. project specific
include: config["rules"] + "data_prep.smk"
include: config["rules"] + "analysis.smk"
# include: config["rules"] + "figures.smk"
include: config["rules"] + "tables.smk"
# 2. Other rules
include: config["rules"] + "renv.smk"
include: config["rules"] + "clean.smk"
include: config["rules"] + "dag.smk"
include: config["rules"] + "help.smk"