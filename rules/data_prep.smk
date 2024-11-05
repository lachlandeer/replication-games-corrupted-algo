

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