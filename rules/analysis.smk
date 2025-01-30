## mechanism regression: Report results of regressions that detail mechanisms
rule mechanism_regression:
    input:
        script = config["src_analysis"] + "mechanism_norms_regression.R",
        data = config["out_data"] + "analysis_data_subjects_with_advice.csv"
    output:
        models = config["out_analysis"] + "mechanism_models.Rds"
    log:
        config["log"] + "analysis/mechanism_norms_regression.txt"
    shell:
        "{runR} {input.script} --data {input.data}  \
            --out {output.models} \
            > {log} {logAll}"

## robustness_all_outcomes_interacted: Results for each reported outcome via LPM using all treatments and interactions
rule robustness_all_outcomes_interacted:
    input:
        script = config["src_analysis"] + "robustness_lpm_all_interacted.R",
        data = config["out_data"] + "analysis_data_subjects_with_advice.csv"
    output:
        models = config["out_analysis"] + "robustness_lpm_all_interacted.Rds"
    log:
        config["log"] + "analysis/robustness_lpm_all_interacted.txt"
    shell:
        "{runR} {input.script} --data {input.data}  \
            --out {output.models} \
            > {log} {logAll}"

## robustness_all_outcomes_simple: Results for each reported outcome via LPM using opacity data
rule robustness_all_outcomes_simple:
    input:
        script = config["src_analysis"] + "robustness_lpm_all_simple.R",
        data = config["out_data"] + "analysis_data_subjects_with_advice.csv"
    output:
        models = config["out_analysis"] + "robustness_lpm_all_simple.Rds"
    log:
        config["log"] + "analysis/robustness_lpm_all_simple.txt"
    shell:
        "{runR} {input.script} --data {input.data}  \
            --out {output.models} \
            > {log} {logAll}"

## report_sixes: Results for the Reported six regressions
rule report_sixes:
    input:
        script = config["src_analysis"] + "report_sixes.R",
        data = config["out_data"] + "analysis_data_subjects_with_advice.csv"
    output:
        models = config["out_analysis"] + "report_six_models.Rds"
    log:
        config["log"] + "analysis/report_sixes.txt"
    shell:
        "{runR} {input.script} --data {input.data}  \
            --out {output.models} \
            > {log} {logAll}"

## report_sixes_hyp_tests:  Hypothesis Tests for reported six regressions to be included in the paper
rule report_sixes_hyp_tests:
    input:
        script = config["src_analysis"] + "report_sixes_coef_tests.R",
        models = config["out_analysis"] + "report_six_models.Rds",
    output:
        json = config["out_analysis"] + "report_six_model_hyps.json"
    log:
        config["log"] + "analysis/report_sixes_coef_tests.txt"
    shell:
        "{runR} {input.script} --models {input.models}  \
            --out {output.json} \
            > {log} {logAll}"

## turing_test: Replicates table 1 of original paper
rule turing_test:
    input:
        script = config["src_analysis"] + "turing_test.R",
        data   = config["out_data"] + "analysis_data_subjects_with_advice.csv", 
    output:
        json = config["out_analysis"] + "turing_test.json"
    log:
        config["log"] + "analysis/turing_test.txt"
    shell:
        "{runR} {input.script} --data {input.data}  \
            --out {output.json} \
            > {log} {logAll}"

## replicate_table_1: Replicates table 1 of original paper
rule replicate_table_1:
    input:
        script = config["src_analysis"] + "replicate_table_1.R",
        data   = config["out_data"] + "analysis_data_subjects_with_advice.csv", 
    output:
        models = config["out_analysis"] + "table_1_models.Rds",
    log:
        config["log"] + "analysis/replicate_table_1.txt"
    shell:
        "{runR} {input.script} --data {input.data}  \
            --out {output.models} \
            > {log} {logAll}"

## replicate_table_1_hc2: Replicates table 1 of original paper with HC2 standard errors
rule replicate_table_1_hc2:
    input:
        script = config["src_analysis"] + "replicate_table_1_heterosk_hc2.R",
        data   = config["out_data"] + "analysis_data_subjects_with_advice.csv", 
    output:
        models = config["out_analysis"] + "table_1_models_hc2.Rds",
    log:
        config["log"] + "analysis/replicate_table_1_heterosk_hc2.txt"
    shell:
        "{runR} {input.script} --data {input.data}  \
            --out {output.models} \
            > {log} {logAll}"   

## replicate_table_1_hc3: Replicates table 1 of original paper with HC3 standard errors
rule replicate_table_1_hc3:
    input:
        script = config["src_analysis"] + "replicate_table_1_heterosk_hc3.R",
        data   = config["out_data"] + "analysis_data_subjects_with_advice.csv", 
    output:
        models = config["out_analysis"] + "table_1_models_hc3.Rds",
    log:
        config["log"] + "analysis/replicate_table_1_heterosk_hc3.txt"
    shell:
        "{runR} {input.script} --data {input.data}  \
            --out {output.models} \
            > {log} {logAll}"     

## t_test_main:   Main treatment comparisons via t-tests with bonferroni corrections
rule t_test_main:
    input: 
        script = config["src_analysis"] + "t_test.R",
        data = config["out_data"] + "analysis_data_subjects_with_advice.csv"
    output:
        tex = config["out_tables"] + "table_ttest_pairwise_dieroll.tex"
    log:
        config["log"] + "analysis/t_test.txt"
    shell:
        "{runR} {input.script} --data {input.data}  \
            --out {output.tex} \
            > {log} {logAll}" 

## t_test_overreport:   Test for overreporting via ttests
rule t_test_overreport:
    input: 
        script = config["src_analysis"] + "ttest_over_report_mean.R",
        data = config["out_data"] + "analysis_data_subjects_with_advice.csv"
    output:
        tex = config["out_tables"] + "table_ttest_overreport.tex"
    log:
        config["log"] + "analysis/ttest_over_report_mean.txt"
    shell:
        "{runR} {input.script} --data {input.data}  \
            --out {output.tex} \
            > {log} {logAll}" 

# t_test_aligned: Additional t tests for the aligned treatemnts
rule t_test_aligned:
    input: 
        script = config["src_analysis"] + "t_test_aligned.R",
        data = config["out_data"] + "analysis_data_subjects_with_advice.csv"
    output:
        tex = config["out_tables"] + "table_ttest_pairwise_dieroll_aligned.tex"
    log:
        config["log"] + "analysis/t_test_aligned.txt"
    shell:
        "{runR} {input.script} --data {input.data}  \
            --out {output.tex} \
            > {log} {logAll}" 
