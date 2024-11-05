## prep_regression_data   : Merge subjects and advice data for main regression specifications
rule prep_regression_data:
    input:
        script = config["src_data_mgt"] + "create_regression_data.R",
        subjects =  config["out_data"] + "analysis_data_subjects.csv",
        advice = config["out_data"] + "analysis_data_advice.csv"
    output:
        data = config["out_data"] + "analysis_data_subjects_with_advice.csv"
    log:
        config["log"] + "data_prep/create_regression_data.txt"
    shell:
        "{runR} {input.script} --subjects {input.subjects} --advice {input.advice} \
            --out {output.data} \
            > {log} {logAll}"

## prep_subjects_data   : Clean up  subjects data 
rule prep_subjects_data:
    input:
        script = config["src_data_mgt"] + "create_analysis_data_subjects.R",
        data =  config["src_data"] + "data.xlsx",
        filtering = config["src_data_specs"] + "subset_replicate_exact.json"
    output:
        data = config["out_data"] + "analysis_data_subjects.csv"
    log:
        config["log"] + "data_prep/create_analysis_data_subjects.txt"
    shell:
        "{runR} {input.script} --data {input.data} --subset {input.filtering} \
            --out {output.data} \
            > {log} {logAll}"

## prep_subjects_data_aligned   : Clean up  subjects data including the aligned treatments
rule prep_subjects_data_aligned:
    input:
        script = config["src_data_mgt"] + "create_data_aligned_treatments.R",
        data =  config["src_data"] + "data.xlsx",
        filtering = config["src_data_specs"] + "subset_replicate_exact.json"
    output:
        data = config["out_data"] + "analysis_data_subjects_aligned.csv"
    log:
        config["log"] + "data_prep/create_data_aligned_treatments.R.txt"
    shell:
        "{runR} {input.script} --data {input.data} --subset {input.filtering} \
            --out {output.data} \
            > {log} {logAll}"

## prep_advice_data   : Clean up the advice data set
rule prep_advice_data:
    input:
        script = config["src_data_mgt"] + "create_analysis_data_advice.R",
        data =  config["src_data"] + "Final_advice_set.xlsx",
    output:
        data = config["out_data"] + "analysis_data_advice.csv"
    log:
        config["log"] + "data_prep/create_analysis_data_advice.txt"
    shell:
        "{runR} {input.script} --data {input.data} \
            --out {output.data} \
            > {log} {logAll}"