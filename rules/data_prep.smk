

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