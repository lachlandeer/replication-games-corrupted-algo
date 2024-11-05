# table_1_tex:   LaTeX output for replication of table 1 of main text
rule table_1_tex:
    input:
        script = config["src_tables"] + "create_table_1.R",
        models = config["out_analysis"] + "table_1_models.Rds"
    output:
        tex = config["out_tables"] + "table_1.tex",
    log:
        config["log"] + "tables/table_1.txt"
    shell:
        "{runR} {input.script} --models {input.models}  \
            --out {output.tex} \
            > {log} {logAll}"

# table_1_tex_hc3:   LaTeX output for replication of table 1 of main text w/ HC3 Std Errors
rule table_1_tex_hc3:
    input:
        script = config["src_tables"] + "create_table_1_hc3.R",
        models = config["out_analysis"] + "table_1_models_hc3.Rds"
    output:
        tex = config["out_tables"] + "table_1_hc3.tex",
    log:
        config["log"] + "tables/table_1_hc3.txt"
    shell:
        "{runR} {input.script} --models {input.models}  \
            --out {output.tex} \
            > {log} {logAll}"

# table_1_tex_hc2:   LaTeX output for replication of table 1 of main text w/ HC2 Std Errors
rule table_1_tex_hc2:
    input:
        script = config["src_tables"] + "create_table_1_hc2.R",
        models = config["out_analysis"] + "table_1_models_hc2.Rds"
    output:
        tex = config["out_tables"] + "table_1_hc2.tex",
    log:
        config["log"] + "tables/table_1_hc2.txt"
    shell:
        "{runR} {input.script} --models {input.models}  \
            --out {output.tex} \
            > {log} {logAll}"
