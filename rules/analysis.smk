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