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

# table_mechanisms:   LaTeX output for replication of mechanism regressions
rule table_mechanisms:
    input:
        script = config["src_tables"] + "create_table_mechanisms.R",
        models = config["out_analysis"] + "mechanism_models.Rds"
    output:
        tex = config["out_tables"] + "table_mechanism.tex",
    log:
        config["log"] + "tables/table_mechanisms.txt"
    shell:
        "{runR} {input.script} --models {input.models}  \
            --out {output.tex} \
            > {log} {logAll}"

# table_mechanisms:   LaTeX output for replication of reporting six regressions
rule table_sixes:
    input:
        script = config["src_tables"] + "create_table_report_sixes.R",
        models = config["out_analysis"] + "report_six_models.Rds"
    output:
        tex = config["out_tables"] + "table_report_sixes.tex",
    log:
        config["log"] + "tables/table_report_sixes.txt"
    shell:
        "{runR} {input.script} --models {input.models}  \
            --out {output.tex} \
            > {log} {logAll}"

# table_lpm_outcomes_all_simple:   LaTeX output for robustness using all outcomes, simple specification
rule table_lpm_outcomes_all_simple:
    input:
        script = config["src_tables"] + "create_table_lpm_outcomes_all_simple.R",
        models = config["out_analysis"] + "robustness_lpm_all_simple.Rds"
    output:
        tex = config["out_tables"] + "robustness_lpm_all_simple.tex",
    log:
        config["log"] + "tables/table_lpm_all_simple.txt"
    shell:
        "{runR} {input.script} --models {input.models}  \
            --out {output.tex} \
            > {log} {logAll}"

# table_lpm_outcomes_all_interacted:   LaTeX output for robustness using all outcomes, treatment interacted specification
rule table_lpm_outcomes_all_interacted:
    input:
        script = config["src_tables"] + "create_table_lpm_outcomes_all_interacted.R",
        models = config["out_analysis"] + "robustness_lpm_all_interacted.Rds"
    output:
        tex = config["out_tables"] + "robustness_lpm_all_interacted.tex",
    log:
        config["log"] + "tables/table_lpm_all_interacted.txt"
    shell:
        "{runR} {input.script} --models {input.models}  \
            --out {output.tex} \
            > {log} {logAll}"