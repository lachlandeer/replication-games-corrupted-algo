# Main Workflow - Corrupted Algorithms
# Contributors: @lachlandeer, Adithya Krishna & Lyla Zhang
import glob

# --- Importing Configuration Files --- #
configfile: "paths.yaml"


# --- Variable Declarations ---- #
runR = "Rscript --no-save --no-restore --verbose"
logAll = "2>&1"

# --- Main Build Rule --- #
# all            : build outputs that are the core of the project
rule all:
    input:
        turing_test         = config["out_analysis"] + "turing_test.json",
        report_sixes_tests  = config["out_analysis"] + "report_six_model_hyps.json",
        rob_over_report     = config["out_analysis"] + "robustness_over_report.json",
        t_test_treatments   = config["out_tables"] + "table_ttest_pairwise_dieroll.tex",
        t_test_overreport   = config["out_tables"] + "table_ttest_overreport.tex",
        t_test_aligned      = config["out_tables"] + "table_ttest_pairwise_dieroll_aligned.tex",
        table_1             = config["out_tables"] + "table_1.tex",
        table_1_hc3         = config["out_tables"] + "table_1_hc3.tex",
        table_1_hc2         = config["out_tables"] + "table_1_hc2.tex",
        table_sixes         = config["out_tables"] + "table_report_sixes.tex",
        table_mechanisms    = config["out_tables"] + "table_mechanism.tex",
        table_rob_simple    = config["out_tables"] + "robustness_lpm_all_simple.tex",
        table_rob_inter     = config["out_tables"] + "robustness_lpm_all_interacted.tex",
        avg_dieroll         = config["out_figures"] + "dieroll_outcome_treatment.pdf",
        dieroll_six         = config["out_figures"] + "prop_sixes.pdf",
        mech_descriptive    = config["out_figures"] + "descriptive_treatment.pdf",
        mech_injunctive     = config["out_figures"] + "injunctive_treatment.pdf",
        mech_justifiability = config["out_figures"] + "justifiability_treatment.pdf",
        mech_shared         = config["out_figures"] + "shared_treatment.pdf"

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
include: config["rules"] + "figures.smk"
include: config["rules"] + "tables.smk"
# 2. Other rules
include: config["rules"] + "renv.smk"
include: config["rules"] + "clean.smk"
include: config["rules"] + "dag.smk"
include: config["rules"] + "help.smk"